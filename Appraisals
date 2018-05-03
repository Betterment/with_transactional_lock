appraise 'rails-4-2' do
  gem 'rails', '~> 4.2.6'
  gem 'pg', '0.21.0', platforms: :ruby
  gem 'mysql2', '0.4.9', platforms: :ruby
  gem 'activerecord-jdbcmysql-adapter', '~> 1.3', platforms: :jruby
  gem 'activerecord-jdbcpostgresql-adapter', '~> 1.3', platforms: :jruby
end

appraise 'rails-5-0' do
  gem 'rails', '5.0.6' # 5.0.7 is broken on jruby
  gem 'pg', '~> 0.1', platforms: :ruby
  gem 'mysql2', '0.4.5', platforms: :ruby
  gem 'activerecord-jdbc-adapter', platforms: :jruby
  gem 'activerecord-jdbcpostgresql-adapter', platforms: :jruby
end
