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
    it "waits with locking enabled" do
      expect(waited_for_lock?(true)).to eq true
    end

    it "doesn't wait with locking disabled" do
      expect(waited_for_lock?(false)).to eq false
    end

    def maybe_transactional_lock(enabled, &block)
      ActiveRecord::Base.connection_pool.with_connection do
        if enabled
          ActiveRecord::Base.with_transactional_lock("foo_bar", &block)
        else
          ActiveRecord::Base.transaction(&block)
        end
      end
    end

    def waited_for_lock?(locking_enabled)
      mutex = Mutex.new
      widget_created = ConditionVariable.new
      threads = []
      result = nil

      threads << Thread.new do
        mutex.lock
        maybe_transactional_lock(locking_enabled) do
          puts "1: waiting"
          widget_created.wait(mutex)
          puts "4: waited"
          Widget.find_by!(name: "foo").destroy
          mutex.unlock
          sleep 1
        end
      end

      threads << Thread.new do
        sleep # must wait for thread_a to acquire mutex
        mutex.synchronize do
          Widget.create!(name: "foo")
          puts "2: signal"
          widget_created.signal
          puts "3: signaled"
        end
        maybe_transactional_lock(locking_enabled) do
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
