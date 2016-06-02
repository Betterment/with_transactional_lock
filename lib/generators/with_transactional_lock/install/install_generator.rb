require 'rails/generators/base'
require 'rails/generators/active_record'

module WithTransactionalLock
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)

      def show_readme
        readme 'README'
      end

      def create_with_transactional_lock_migration
        if mysql?
          migration_template(
            'db/migrate/create_transactional_advisory_locks.rb',
            'db/migrate/create_transactional_advisory_locks.rb'
          )
        end
      end

      def self.next_migration_number(dir)
        ActiveRecord::Generators::Base.next_migration_number(dir)
      end

      private

      def mysql?
        ActiveRecord::Base.connection.adapter_name.downcase =~ /mysql/
      end
    end
  end
end

