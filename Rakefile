require "rspec/core/rake_task"
require 'rdoc/task'
require "bundler/gem_tasks"

RSpec::Core::RakeTask.new(:test)

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "mail_safe #{MailSafe::VERSION}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :default => :test
