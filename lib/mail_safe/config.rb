module MailSafe
  class InvalidConfigSettingError < StandardError; end

  class Config
    cattr_accessor :internal_address_definition

    def self.is_internal_address?(address)
      case internal_address_definition
        when Regexp then address =~ internal_address_definition
        when Proc   then internal_address_definition.call(address)
        else raise InvalidConfigSettingError.new("internal_address_definition must be a Regexp or Proc, but was: #{internal_address_definition.class.to_s}")
      end
    end

    cattr_accessor :replacement_address

    def self.get_replacement_address(original_address)
      case replacement_address
        when String then replacement_address
        when Proc   then replacement_address.call(original_address)
        else raise InvalidConfigSettingError.new("replacement_address must be a String or Proc, but was: #{replacement_address.class.to_s}")
      end
    end
  end
end