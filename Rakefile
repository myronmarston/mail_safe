require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "mail_safe"
    gem.summary = %Q{Keep your ActionMailer emails from escaping into the wild during development.}
    gem.email = "myron.marston@gmail.com"
    gem.homepage = "http://github.com/myronmarston/mail_safe"
    gem.authors = ["Myron Marston"]

    gem.add_dependency 'actionmailer',  '>= 1.3.6'
    gem.add_development_dependency 'rspec', '>= 1.2.9'

    gem.files.exclude 'vendor/ginger'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec) do |t|
  #t.rspec_opts = %w[--format documentation]
end

task :spec => :check_dependencies if defined?(Jeweler)

task :default => :ginger

require 'rake/rdoctask'
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

desc 'Run ginger tests'
task :ginger do
  $LOAD_PATH << File.join(*%w[vendor ginger lib])
  ARGV.clear
  ARGV << 'spec'
  load File.join(*%w[vendor ginger bin ginger])
end
