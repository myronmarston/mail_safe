require 'rspec'
require 'rubygems'

$LOAD_PATH << File.join(File.dirname(__FILE__), *%w[.. vendor ginger lib])
require 'ginger'
require 'mail_safe'
require 'mailers/test_mailer'

begin
  require 'ruby-debug'
  Debugger.start
  Debugger.settings[:autoeval] = true if Debugger.respond_to?(:settings)
rescue LoadError
  # ruby-debug wasn't available so neither can the debugging be
end

ActionMailer::Base.delivery_method = :test

RSpec.configure do |config|
  config.color_enabled = true
  config.debug = true
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end

