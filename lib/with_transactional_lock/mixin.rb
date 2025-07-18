# frozen_string_literal: true

require 'active_support/concern'

module WithTransactionalLock
  module Mixin
    extend ActiveSupport::Concern
    delegate :with_transactional_lock, to: :class

    module ClassMethods
      def with_transactional_lock(lock_name, &)
        _advisory_lock_class.new(connection, lock_name).yield_with_lock(&)
      end

      private

      def _advisory_lock_class
        @_advisory_lock_class ||= AdvisoryLockClassLocator.locate(connection)
      end
    end

    module AdvisoryLockClassLocator
      def self.locate(connection)
        adapter = connection.adapter_name.downcase.to_sym
        case adapter
        when :postgresql
          PostgresAdvisoryLock
        else
          raise "adapter not supported: #{adapter}"
        end
      end
    end

    class AdvisoryLockBase
      attr_reader :connection, :lock_name

      def initialize(connection, lock_name)
        @connection = connection
        @lock_name = lock_name
      end

      def yield_with_lock
        connection.transaction do
          acquire_lock
          yield
        end
      end

      private

      def db_lock_name
        @db_lock_name ||= Digest::SHA256.digest(lock_name)[0, 8].unpack1('q')
      end
    end

    class PostgresAdvisoryLock < AdvisoryLockBase
      private

      def acquire_lock
        connection.execute("select pg_advisory_xact_lock(#{connection.quote(db_lock_name)})")
      end
    end
  end
end
