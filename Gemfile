source 'https://rubygems.org'
git_source(:private_git) { |repo_name| "https://betterment-deploy:823e1e8cb95139adf333f730626dc5a05fb26046@github.com/#{repo_name}" }

gemspec

gem 'pg', platforms: :ruby
gem 'mysql2', platforms: :ruby

gem 'activerecord-jdbcmysql-adapter', platforms: :jruby
gem 'activerecord-jdbcpostgresql-adapter', platforms: :jruby

gem 'rspec-rails', '~> 3.1'
gem 'travis'
gem 'mime-types', '< 3'
gem 'rspec-retry'
gem 'database_cleaner'

gem 'rubocop-betterment', private_git: 'Betterment/rubocop-betterment', require: false
