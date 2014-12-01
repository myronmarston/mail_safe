module MailSafe
  class InvalidConfigSettingError < StandardError; end

  class Config
    cattr_accessor :internal_address_definition

    def self.is_internal_address?(address)
      case internal_address_definition
        when Regexp then !!(address =~ internal_address_definition)
        when Proc   then internal_address_definition.call(address)
        else
          return address.downcase == developer_email_address.downcase if developer_email_address
          raise InvalidConfigSettingError.new("Ensure internal_address_definition is a Regexp or a Proc. It was: #{internal_address_definition.class.to_s}")
      end
    end

    cattr_accessor :replacement_address

    def self.get_replacement_address(original_address)
      case replacement_address
        when String then replacement_address
        when Proc   then replacement_address.call(original_address)
        else
          return developer_email_address if developer_email_address
          raise InvalidConfigSettingError.new("Ensure replacement_address is a String or a Proc. It was: #{replacement_address.class.to_s}. Or at least set your user email in git.")
      end
    end

    def self.developer_email_address
      unless defined?(@@developer_email_address)
        @@developer_email_address = begin
          `git config user.email`.strip
        rescue
          nil
        end
        @@developer_email_address = nil  if @@developer_email_address.blank?
      end

      @@developer_email_address
    end
  end
end
