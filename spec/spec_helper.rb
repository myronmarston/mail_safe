require 'mail_safe'
require 'mailers/test_mailer'

ActionMailer::Base.delivery_method = :test

require 'rspec'
RSpec.configure do |config|
  config.color = true
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end

require "coveralls"
Coveralls.wear!