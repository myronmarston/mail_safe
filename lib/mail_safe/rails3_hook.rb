require 'mail'

module MailSafe
  class MailInterceptor
    def self.delivering_email(mail)
      MailSafe::AddressReplacer.replace_external_addresses(mail) if mail
      MailSafe::Config.email_strategy.new.process_email(mail) if mail
    end

    ::Mail.register_interceptor(self)
  end
end
