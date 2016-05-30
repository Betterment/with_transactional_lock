rails_env = ENV['RAILS_ENV'] ||= 'test'
db_adapter = ENV['DB_ADAPTER'] ||= 'postgresql'
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

Rails.configuration.database_configuration[db_adapter][rails_env].tap do |c|
  ActiveRecord::Base.establish_connection(c)
  ActiveRecord::Tasks::DatabaseTasks.create(c)
  ActiveRecord::Base.establish_connection(c)
  load File.expand_path("../dummy/db/schema.rb",  __FILE__)
end

require 'rspec/rails'

class Widget < ActiveRecord::Base
end

RSpec.configure do |config|
  config.order = :random

  config.use_transactional_fixtures = false

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
