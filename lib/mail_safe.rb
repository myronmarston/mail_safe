require 'action_mailer'
require 'action_mailer/version'
require 'active_support/core_ext/class/attribute_accessors' # to be able to use cattr_accessor

require 'mail_safe/config'
require 'mail_safe/address_replacer'

# Set flag to avoid warning. Introduced in I18N v0.6.6
if I18n.config.respond_to? :enforce_available_locales=
  I18n.config.enforce_available_locales = false
end

if ActionMailer::VERSION::MAJOR < 3
  require 'mail_safe/rails2_hook'
else
  require 'mail_safe/rails3_hook'
end