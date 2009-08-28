require 'active_support'
require 'action_mailer'

require 'mail_safe/config'
require 'mail_safe/action_mailer'
require 'mail_safe/address_replacer'

ActionMailer::Base.send(:include, MailSafe::ActionMailer) unless ActionMailer::Base.ancestors.include?(MailSafe::ActionMailer)