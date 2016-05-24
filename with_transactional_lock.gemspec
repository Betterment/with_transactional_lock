$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "with_transactional_lock/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "with_transactional_lock"
  s.version     = WithTransactionalLock::VERSION
  s.authors     = ["Sam Moore"]
  s.email       = ["sam@betterment.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of WithTransactionalLock."
  s.description = "TODO: Description of WithTransactionalLock."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 4.2"
end
