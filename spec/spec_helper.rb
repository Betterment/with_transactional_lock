# frozen_string_literal: true

rails_env = ENV['RAILS_ENV'] ||= 'test'
db_adapter = ENV['DB_ADAPTER'] ||= 'postgresql'
require File.expand_path("dummy/config/environment.rb", __dir__)

Rails.configuration.database_configuration[db_adapter][rails_env].tap do |c|
  ActiveRecord::Tasks::DatabaseTasks.create(c)
  ActiveRecord::Base.establish_connection(c)
  load File.expand_path("dummy/db/schema.rb", __dir__)
end

require 'rspec/rails'
require 'rspec/retry'
require 'mime-types'
require 'database_cleaner'

class Widget < ActiveRecord::Base
end

RSpec.configure do |config|
  config.order = :random

  config.use_transactional_fixtures = false
  config.verbose_retry = true
  config.display_try_failure_messages = true

  config.before(:suite) do
    DatabaseCleaner.strategy = :deletion
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
