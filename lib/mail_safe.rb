require 'action_mailer'
require 'action_mailer/version'

require 'mail_safe/config'
require 'mail_safe/address_replacer'

if ActionMailer::VERSION::MAJOR < 3
  require 'mail_safe/rails2_hook'
else
  require 'mail_safe/rails3_hook'
end