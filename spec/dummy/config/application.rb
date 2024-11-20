# frozen_string_literal: true

require 'bundler/setup'
require 'active_record/railtie'

Bundler.require(:default, Rails.env)
require 'with_transactional_lock'

module Dummy
  class Application < Rails::Application
    config.root = File.expand_path('..', __dir__)
    config.load_defaults Rails::VERSION::STRING.to_f
    config.eager_load = Rails.env.test?
    config.cache_classes = Rails.env.test?
  end
end
