$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'spec'
require 'spec/autorun'

begin
  require 'ruby-debug'
  Debugger.start
  Debugger.settings[:autoeval] = true if Debugger.respond_to?(:settings)
rescue LoadError
  # ruby-debug wasn't available so neither can the debugging be
end

require 'rubygems'
require 'mail_safe'
require 'mailers/test_mailer'

ActionMailer::Base.delivery_method = :test

Spec::Runner.configure do |config|
end