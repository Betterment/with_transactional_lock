require 'spec_helper'

describe WithTransactionalLock do
  before do
    ActiveRecord::Base.connection.reconnect!
  end

  after do
    Widget.delete_all
    WithTransactionalLock::MySqlHelper.cleanup if ENV['DB_ADAPTER'] == 'mysql'
  end

  it 'allows claiming the same lock twice' do
    Widget.create!(name: 'other')
    Widget.with_transactional_lock('Widget.first') do
      Widget.first.update!(name: 'once')
      Widget.with_transactional_lock('Widget.first') do
        Widget.first.tap do |w|
          w.name += 'twice'
          w.save!
        end
      end
    end
    expect(Widget.first.name).to eq 'oncetwice'
  end

  context 'concurrency prevention' do
    it "waits with locking enabled and the same lock name" do
      expect(waited_for_lock?(locking_enabled: true, distinct_lock_names: false)).to eq true
    end

    it "doesn't wait with locking enabled and distinct lock names" do
      expect(waited_for_lock?(locking_enabled: true, distinct_lock_names: true)).to eq false
    end

    it "doesn't wait with locking disabled" do
      expect(waited_for_lock?(locking_enabled: false)).to eq false
    end

    def maybe_transactional_lock(enabled, lock_name, &block)
      ActiveRecord::Base.connection_pool.with_connection do
        if enabled
          ActiveRecord::Base.with_transactional_lock(lock_name, &block)
        else
          ActiveRecord::Base.transaction(&block)
        end
      end
    end

    def waited_for_lock?(opts)
      locking_enabled = opts[:locking_enabled]
      raise("must provide locking_enabled: option") if opts[:locking_enabled].nil?

      raise("must provide distinct_lock_names: option if locking is enabled") if locking_enabled && opts[:distinct_lock_names].nil?

      lock_one_name = "lock_one"
      lock_two_name = opts[:distinct_lock_names] ? "lock_two" : lock_one_name

      mutex = Mutex.new
      widget_created = ConditionVariable.new
      threads = []
      result = nil

      threads << Thread.new do
        mutex.lock
        maybe_transactional_lock(locking_enabled, lock_one_name) do
          widget_created.wait(mutex)
          Widget.find_by!(name: "foo").destroy
          mutex.unlock
          sleep 1
        end
      end

      threads << Thread.new do
        sleep # must wait for thread_a to acquire mutex
        mutex.synchronize do
          Widget.create!(name: "foo")
          widget_created.signal
        end
        maybe_transactional_lock(locking_enabled, lock_two_name) do
          result = Widget.where(name: "foo").empty?
        end
      end

      # sleeping the second thread roughly ensures that the first thread will run first
      sleep(0.1) until threads[1].status == 'sleep'
      threads[1].wakeup

      threads.each(&:join)
      result
    end
  end
end
