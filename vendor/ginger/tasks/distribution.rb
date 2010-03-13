require 'jeweler'
require 'yard'

YARD::Rake::YardocTask.new

Jeweler::Tasks.new do |gem|
  gem.name        = 'ginger'
  gem.summary     = 'Run rake tasks multiple times with different gem versions.'
  gem.description = 'Run rake tasks multiple times with different gem versions.'
  gem.email       = "pat@freelancing-gods.com"
  gem.homepage    = "http://github.com/freelancing_god/ginger/tree"
  gem.authors     = ["Pat Allan"]
  
  gem.add_development_dependency "rspec",    ">= 1.2.9"
  gem.add_development_dependency "yard",     ">= 0"
  
  gem.files = FileList[
    'bin/*',
    'lib/**/*.rb',
    'LICENCE',
    'README.textile'
  ]
  gem.test_files = FileList[
    'spec/**/*'
  ]
end

Jeweler::GemcutterTasks.new
