require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
    gem.name = "mail_safe"
    gem.summary = %Q{Keep your ActionMailer emails from escaping into the wild during development.}
    gem.email = "myron.marston@gmail.com"
    gem.homepage = "http://github.com/myronmarston/mail_safe"
    gem.authors = ["Myron Marston"]

    gem.add_dependency 'actionmailer',  '>= 1.3.6'
    gem.add_development_dependency 'rspec', '>= 1.2.9'
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

require "rspec/core/rake_task"

task :spec => :check_dependencies if defined?(Jeweler)

RSpec::Core::RakeTask.new(:test)

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    require 'yaml' unless defined?(YAML) # seems to be needed for ruby 1.9.1
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "mail_safe #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
