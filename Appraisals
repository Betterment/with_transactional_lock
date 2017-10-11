appraise "rails-4-2" do
  gem "rails", "~> 4.2.6"
  gem 'activerecord-jdbcmysql-adapter', platforms: :jruby
  gem 'activerecord-jdbcpostgresql-adapter', platforms: :jruby
end

appraise "rails-5-0" do
  gem "rails", "~> 5.0.4"
  gem 'activerecord-jdbc-adapter', github: 'jruby/activerecord-jdbc-adapter', branch: 'rails-5', platforms: :jruby
  gem 'activerecord-jdbcpostgresql-adapter', github: 'jruby/activerecord-jdbc-adapter', branch: 'rails-5', platforms: :jruby
end
