# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require "with_transactional_lock/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "with_transactional_lock"
  s.version     = WithTransactionalLock::VERSION
  s.authors     = ["Sam Moore"]
  s.email       = ["sam@betterment.com"]
  s.homepage    = "https://github.com/Betterment/with_transactional_lock"
  s.summary     = "Transactional advisory locks for ActiveRecord"
  s.description = "Advisory locking support for MySQL and Postgresql done right."
  s.license     = "MIT"
  s.metadata['allowed_push_host'] = 'https://rubygems.org'
  s.metadata['rubygems_mfa_required'] = 'true' # in case we ever use rubygems

  s.files = Dir["lib/**/*", "LICENSE", "Rakefile", "README.md"]

  s.add_dependency 'activerecord', '>= 7.0', '< 7.2'
  s.add_dependency 'railties', '>= 7.0', '< 7.2'

  s.add_development_dependency 'appraisal', '~> 2.2.0'
  s.add_development_dependency 'betterlint'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'mime-types'
  s.add_development_dependency 'mysql2'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rspec-retry'

  s.required_ruby_version = '>= 3.2'
end
