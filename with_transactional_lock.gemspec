$:.push File.expand_path("../lib", __FILE__)

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

  s.files = Dir["lib/**/*", "LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 4.2"
end
