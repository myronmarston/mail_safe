module MailSafe
  module ActionMailer
    def self.included(base)
      base.class_eval do
        alias_method_chain :deliver!, :mail_safe
      end
    end

    def deliver_with_mail_safe!(mail = @mail)
      MailSafe::Config.email_strategy.new.process_email(mail) if mail
      unless mail.to.nil?
        deliver_without_mail_safe!(mail)
      end
    end
  end
end

ActionMailer::Base.send(:include, MailSafe::ActionMailer) unless ActionMailer::Base.ancestors.include?(MailSafe::ActionMailer)
