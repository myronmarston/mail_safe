require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha'

begin
  require 'ruby-debug'
  Debugger.start
  Debugger.settings[:autoeval] = true if Debugger.respond_to?(:settings)
rescue LoadError
  # ruby-debug wasn't available so neither can the debugging be
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'mail_safe'
require 'mailers/test_mailer'

ActionMailer::Base.delivery_method = :test

class Test::Unit::TestCase
end
