module MailSafe
  class AddressReplacer
    class << self
      ADDRESS_TYPES = [:to, :cc, :bcc].freeze

      def replace_external_addresses(mail)
        replaced_addresses = {}

        ADDRESS_TYPES.each do |address_type|
          if addresses = mail.send(address_type)
            new_addresses = []

            addresses.each do |a|
              new_addresses << if MailSafe::Config.is_internal_address?(a)
                a
              else
                (replaced_addresses[address_type] ||= []) << a
                MailSafe::Config.get_replacement_address(a)
              end
            end

            mail.send("#{address_type}=", new_addresses)
          end
        end

        self.add_body_postscript(mail, replaced_addresses)
      end

      protected

      def add_body_postscript(part, replaced_addresses)
        return unless replaced_addresses.size > 0

        case part.content_type
          when %r{^text/plain} then add_text_postscript(part, replaced_addresses)
          when %r{^text/html}  then add_html_postscript(part, replaced_addresses)
        end

        part.parts.each { |p| add_body_postscript(p, replaced_addresses) }
      end

      def add_text_postscript(part, replaced_addresses)
        address_type_postscripts = []
        ADDRESS_TYPES.each do |address_type|
          next unless addresses = replaced_addresses[address_type]
          address_type_postscripts << "- #{address_type}:\n  - #{addresses.join("\n  - ")}"
        end

        postscript = <<-EOS


**************************************************
This email originally had different recipients,
but MailSafe has prevented it from being sent to them.

The original recipients were:
#{address_type_postscripts.join("\n\n")}

**************************************************
        EOS

        add_postscript(part, postscript)
      end

      def add_html_postscript(part, replaced_addresses)
        address_type_postscripts = []
        ADDRESS_TYPES.each do |address_type|
          next unless addresses = replaced_addresses[address_type]
          address_type_postscripts << "#{address_type}:<ul>\n<li>#{addresses.join("</li>\n<li>")}</li>\n</ul>"
        end

        postscript = <<-EOS
          <div class="mail-safe-postscript">
            <hr />

            <p>
              This email originally had different recipients,
              but MailSafe has prevented it from being sent to them.
            </p>

            <p>
              The original recipients were:
            </p>

            <ul>
              <li>
                #{address_type_postscripts.join("</li>\n<li>")}
              </li>
            </ul>

            <hr/ >
          </div>
        EOS

        add_postscript(part, postscript)
      end

      if ActionMailer::VERSION::MAJOR < 3
        include ::ActionMailer::Utils

        def add_postscript(part, postscript)
          body = part.body + postscript

          # taken from action mailer:
          # http://github.com/rails/rails/blob/05d7409ae5fd423be6f747ad553f659fcecbf548/actionmailer/lib/action_mailer/part.rb#L58-65
          case part.content_transfer_encoding.to_s.downcase
            when "base64" then
              part.body = TMail::Base64.folding_encode(body)
            when "quoted-printable"
              part.body = [normalize_new_lines(body)].pack("M*")
            else
              part.body = body
          end
        end
      else
        def add_postscript(part, postscript)
          postscript = postscript.html_safe  if postscript.respond_to?(:html_safe)
          part.body = part.body.to_s + postscript
        end
      end
    end
  end
end
