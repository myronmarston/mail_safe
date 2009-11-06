require 'test_helper'

class ConfigTest < Test::Unit::TestCase
  context '#developer_email_address' do
    teardown do
      # clear class variable caching...
      MailSafe::Config.class_eval do
        remove_class_variable(:@@developer_email_address)
      end
    end

    context 'when git is installed' do
      setup do
        backtick_call_count = 0
        # mock out the ` method.  I can't find a simpler way to do this with mocha.
        Kernel.class_eval do
          define_method '`'.to_sym do |cmd|
            backtick_call_count += 1
            return "too many calls" if backtick_call_count > 1
            if cmd == 'git config user.email'
              "developer@domain.com\n"
            end
          end
        end
      end

      should "guess the developer's email address using git" do
        assert_equal 'developer@domain.com', MailSafe::Config.developer_email_address
      end

      should "cache the developer's email address so multiple system calls aren't made" do
        assert_equal MailSafe::Config.developer_email_address, MailSafe::Config.developer_email_address
      end
    end

    context 'when git is not installed' do
      setup do
        backtick_call_count = 0
        # mock out the ` method.  I can't find a simpler way to do this with mocha.
        Kernel.class_eval do
          define_method '`'.to_sym do |cmd|
            backtick_call_count += 1
            return "too many calls" if backtick_call_count > 1
            if cmd == 'git config user.email'
              raise RuntimeError.new("Git is not installed")
            end
          end
        end
      end

      should "return nil" do
        assert_nil MailSafe::Config.developer_email_address
      end

      should "cache the developer's email address so multiple system calls aren't made" do
        assert_equal MailSafe::Config.developer_email_address, MailSafe::Config.developer_email_address
      end
    end
  end

  context '#is_internal_address?' do
    context 'when internal_address_definition is not set' do
      setup do
        MailSafe::Config.internal_address_definition = nil
      end

      context 'and #developer_email_address has a value' do
        setup do
          @developer_address = 'developer@domain.com'
          MailSafe::Config.expects(:developer_email_address).at_least_once.returns(@developer_address)
        end

        should 'return true when passed the developer email address' do
          assert MailSafe::Config.is_internal_address?(@developer_address)
        end

        should 'return true when passed the developer email address with different casing' do
          assert MailSafe::Config.is_internal_address?(@developer_address.upcase)
        end

        should 'return false when passed another email address' do
          assert !MailSafe::Config.is_internal_address?('another-address@domain.com')
        end
      end

      context 'and #developer_email_address has no value' do
        setup do
          MailSafe::Config.expects(:developer_email_address).returns(nil)
        end

        should 'raise an error' do
          assert_raise MailSafe::InvalidConfigSettingError do
            MailSafe::Config.is_internal_address?('abc@foo.com')
          end
        end
      end
    end

    context 'when internal_address_definition is set to a regexp' do
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
  end

  context '#get_replacement_address' do
    context 'when replacement_address is set to a string' do
      setup do
        MailSafe::Config.replacement_address = 'me@mydomain.com'
      end

      should 'return the configured replacement address' do
        assert_equal 'me@mydomain.com', MailSafe::Config.get_replacement_address('you@example.com')
      end
    end

    context 'when replacement_address is set to a proc' do
      setup do
        MailSafe::Config.replacement_address = lambda { |address| "me+#{address.split('@').first}@mydomain.com" }
      end

      should 'return the configured replacement address' do
        assert_equal 'me+you@mydomain.com', MailSafe::Config.get_replacement_address('you@example.com')
      end
    end

    context 'when replacement_address is not set' do
      setup do
        MailSafe::Config.replacement_address = nil
      end

      context 'and #developer_email_address has a value' do
        setup do
          @developer_address = 'developer@domain.com'
          MailSafe::Config.expects(:developer_email_address).at_least_once.returns(@developer_address)
        end

        should 'return the developer address' do
          assert_equal @developer_address, MailSafe::Config.get_replacement_address('you@example.com')
        end
      end

      context 'and #developer_email_address has no value' do
        setup do
          MailSafe::Config.expects(:developer_email_address).returns(nil)
        end

        should 'raise an error' do
          assert_raise MailSafe::InvalidConfigSettingError do
            MailSafe::Config.get_replacement_address('you@example.com')
          end
        end
      end
    end
  end
end
