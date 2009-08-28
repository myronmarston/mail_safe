require 'test_helper'

class ConfigTest < Test::Unit::TestCase
  context 'When internal_address_definition is set to a regexp, #is_internal_address?' do
    setup do
      MailSafe::Config.internal_address_definition = /.*@example\.com/
    end

    should 'return true if the address matches the regexp' do
      assert MailSafe::Config.is_internal_address?('someone@example.com')
    end

    should 'return false if the address does not match the regexp' do
      assert !MailSafe::Config.is_internal_address?('someone@another-domain.com')
    end
  end

  context 'When internal_address_definition is set to a lambda, #is_internal_address?' do
    setup do
      MailSafe::Config.internal_address_definition = lambda { |address| address.size < 15 }
    end

    should 'return true if the lambda returns true for the given address' do
      assert MailSafe::Config.is_internal_address?('abc@foo.com')
    end

    should 'return false if the lambda returns false for the given address' do
      assert !MailSafe::Config.is_internal_address?('a-long-address@example.com')
    end
  end

  context 'When internal_address_definition is not set, #is_internal_address?' do
    setup do
      MailSafe::Config.internal_address_definition = nil
    end

    should 'raise an error' do
      assert_raise MailSafe::InvalidConfigSettingError do
        MailSafe::Config.is_internal_address?('abc@foo.com')
      end
    end
  end

  context 'When replacement_address is set to a string, #get_replacement_address' do
    setup do
      MailSafe::Config.replacement_address = 'me@mydomain.com'
    end

    should 'return the configured replacement address' do
      assert_equal 'me@mydomain.com', MailSafe::Config.get_replacement_address('you@example.com')
    end
  end

  context 'When replacement_address is set to a proc, #get_replacement_address' do
    setup do
      MailSafe::Config.replacement_address = lambda { |address| "me+#{address.split('@').first}@mydomain.com" }
    end

    should 'return the configured replacement address' do
      assert_equal 'me+you@mydomain.com', MailSafe::Config.get_replacement_address('you@example.com')
    end
  end

  context 'When replacement_address is not set, #get_replacement_address' do
    setup do
      MailSafe::Config.replacement_address = nil
    end

    should 'raise an error' do
      assert_raise MailSafe::InvalidConfigSettingError do
        MailSafe::Config.get_replacement_address('you@example.com')
      end
    end
  end
end
