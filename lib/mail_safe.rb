require 'active_support'
require 'action_mailer'
require 'action_mailer/version'

require 'mail_safe/config'
require 'mail_safe/address_replacer'

if ActionMailer::VERSION::MAJOR < 3
  require 'mail_safe/action_mailer_for_rails2'
  ActionMailer::Base.send(:include, MailSafe::ActionMailer) unless ActionMailer::Base.ancestors.include?(MailSafe::ActionMailer)
else
end