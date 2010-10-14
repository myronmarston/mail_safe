require 'rubygems'

$LOAD_PATH << File.join(File.dirname(__FILE__), *%w[.. vendor ginger lib])
require 'ginger'
require 'mail_safe'
require 'mailers/test_mailer'

ActionMailer::Base.delivery_method = :test

require 'rspec'
RSpec.configure do |config|
  config.color_enabled = true
  config.debug = true
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end

