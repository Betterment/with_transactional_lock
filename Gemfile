source 'https://rubygems.org'
git_source(:private_git) { |repo_name| "https://betterment-deploy:de4372bdef0377c76679aabdcea71a92fbf467ab@github.com/#{repo_name}" }

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
