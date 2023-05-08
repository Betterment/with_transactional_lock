begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rdoc/task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'WithTransactionalLock'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

APP_RAKEFILE = File.expand_path('spec/dummy/Rakefile', __dir__)
load 'rails/tasks/engine.rake'
load 'rails/tasks/statistics.rake'

Bundler::GemHelper.install_tasks

if (Rails.env.development? || Rails.env.test?) && defined? Dummy
  require 'rspec/core'
  require 'rspec/core/rake_task'
  require 'rubocop/rake_task'

  RuboCop::RakeTask.new
  RSpec::Core::RakeTask.new(:spec)

  task(:default).clear
  if ENV['APPRAISAL_INITIALIZED'] || ENV['CI']
    tasks += [:rubocop] unless ENV['CI']

    task default: tasks
  else
    require 'appraisal'
    Appraisal::Task.new
    task default: :appraisal
  end
end
