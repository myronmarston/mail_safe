module MailSafe
  module Strategy
    class Remove
      ADDRESS_TYPES = [:to, :cc, :bcc].freeze
      def process_email(mail)
        ADDRESS_TYPES.each do |address_type|
          if addresses = mail.send(address_type)
            new_addresses = []

            addresses.each do |a|
              if MailSafe::Config.is_internal_address?(a)
                new_addresses << a
              end
            end

            mail.send("#{address_type}=", new_addresses)
          end
        end
      end
    end
  end
end
