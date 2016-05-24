require 'spec_helper'

describe WithTransactionalLock do
  before do
    ActiveRecord::Base.connection.reconnect!
  end

  after do
    Widget.delete_all
    ActiveRecord::Base.connection.execute('delete from advisory_locks') if ENV['DB_ADAPTER'] == 'mysql'
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

  describe 'concurrency protection' do
    context 'with locking' do
      it 'creates no duplicate resoucres' do
        work_work_work_work_work(times: 5, with_lock: true)
        expect(Widget.count).to eq 5
      end
    end

    context 'without locking' do
      it 'creates duplicate resources' do
        work_work_work_work_work(times: 5, with_lock: false)
        expect(Widget.count).to be > 5
      end
    end
  end

  def work_work_work_work_work(opts={})
    iterations = opts.fetch(:times)
    with_lock = opts.fetch(:with_lock)
    [].tap do |ary|
      iterations.times do
        iterations.times do |i|
          ary << Thread.new do
            sleep
            ActiveRecord::Base.connection_pool.with_connection do
              if with_lock
                Widget.with_transactional_lock('Widget.first') do
                  Widget.where(name: "widget #{i}").first_or_create
                end
              else
                Widget.where(name: "widget #{i}").first_or_create
              end
            end
          end
        end
      end
      until ary.all? { |t| t.status == 'sleep' }
        sleep(0.1)
      end
      ary.each(&:wakeup).each(&:join)
    end
  end
end
