require 'mail'

module MailSafe
  class MailInterceptor
    def self.delivering_email(message)
      MailSafe::AddressReplacer.replace_external_addresses(message) if message
    end

    ::Mail.register_interceptor(self)
  end
end