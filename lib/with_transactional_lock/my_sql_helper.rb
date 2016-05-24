# frozen_string_literal: true

module WithTransactionalLock
  class MySqlHelper
    def self.cleanup(klass = ActiveRecord::Base)
      klass.connection_pool.with_connection do |conn|
        target_count = conn.select_value('select count(1) from transactional_advisory_locks')
        count = 0
        count += conn.delete('delete from transactional_advisory_locks limit 1000') until count >= target_count
      end
    end
  end
end
