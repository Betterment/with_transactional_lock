module WithTransactionalLock
  class MySqlHelper
    def self.cleanup(klass = ActiveRecord::Base)
      klass.connection_pool.with_connection do |conn|
        target_count = conn.select_value('select count(1) from advisory_locks')
        count = 0
        until count >= target_count
          count += conn.delete('delete from advisory_locks limit 1000')
        end
      end
    end
  end
end
