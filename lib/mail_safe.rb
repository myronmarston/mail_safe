require 'action_mailer'
require 'action_mailer/version'

require 'mail_safe/strategy/replace'
require 'mail_safe/strategy/remove'
require 'mail_safe/config'

if ActionMailer::VERSION::MAJOR < 3
  require 'mail_safe/rails2_hook'
else
  require 'mail_safe/rails3_hook'
end
