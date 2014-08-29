require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe MailSafe::Config do
  describe '#developer_email_address' do
    after(:each) do
      # clear class variable caching...
      MailSafe::Config.class_eval do
        remove_class_variable(:@@developer_email_address)
      end
    end

    context 'when git is installed' do
      before(:each) do
        expect(MailSafe::Config).to receive(:`).with('git config user.email').once.and_return("developer@domain.com\n")
      end

      it "guesses the developer's email address using git" do
        expect(MailSafe::Config.developer_email_address).to eq('developer@domain.com')
      end

      it "caches the developer's email address so multiple system calls aren't made" do
        expect(MailSafe::Config.developer_email_address).to eq(MailSafe::Config.developer_email_address)
      end
    end

    context 'when git is not installed' do
      before(:each) do
        expect(MailSafe::Config).to receive(:`).with('git config user.email').once.and_return(nil)
      end

      it "returns nil" do
        expect(MailSafe::Config.developer_email_address).to be_nil
      end

      it "caches the developer's email address so multiple system calls aren't made" do
        expect(MailSafe::Config.developer_email_address).to eq(MailSafe::Config.developer_email_address)
      end
    end
  end

  describe '#is_internal_address?' do
    context 'when internal_address_definition is not set' do
      before(:each) do
        MailSafe::Config.internal_address_definition = nil
      end

      context 'and #developer_email_address has a value' do
        before(:each) do
          @developer_address = 'developer@domain.com'
          expect(MailSafe::Config).to receive(:developer_email_address).at_least(1).and_return(@developer_address)
        end

        it 'returns true when passed the developer email address' do
          expect(MailSafe::Config.is_internal_address?(@developer_address)).to be_truthy
        end

        it 'returns true when passed the developer email address with different casing' do
          expect(MailSafe::Config.is_internal_address?(@developer_address.upcase)).to be_truthy
        end

        it 'returns false when passed another email address' do
          expect(MailSafe::Config.is_internal_address?('another-address@domain.com')).to be_falsey
        end
      end

      context 'and #developer_email_address has no value' do
        before(:each) do
          expect(MailSafe::Config).to receive(:developer_email_address).and_return(nil)
        end

        it 'raises an error' do
          expect { MailSafe::Config.is_internal_address?('abc@foo.com') }.to raise_error(MailSafe::InvalidConfigSettingError)
        end
      end
    end

    context 'when internal_address_definition is set to a regexp' do
      before(:each) do
        MailSafe::Config.internal_address_definition = /.*@example\.com/
      end

      it 'returns true if the address matches the regexp' do
        expect(MailSafe::Config.is_internal_address?('someone@example.com')).to be_truthy
      end

      it 'returns false if the address does not match the regexp' do
        expect(MailSafe::Config.is_internal_address?('someone@another-domain.com')).to be_falsey
      end
    end

    context 'When internal_address_definition is set to a lambda, #is_internal_address?' do
      before(:each) do
        MailSafe::Config.internal_address_definition = lambda { |address| address.size < 15 }
      end

      it 'returns true if the lambda returns true for the given address' do
        expect(MailSafe::Config.is_internal_address?('abc@foo.com')).to be_truthy
      end

      it 'returns false if the lambda returns false for the given address' do
        expect(MailSafe::Config.is_internal_address?('a-long-address@example.com')).to be_falsey
      end
    end
  end

  describe '#get_replacement_address' do
    context 'when replacement_address is set to a string' do
      before(:each) do
        MailSafe::Config.replacement_address = 'me@mydomain.com'
      end

      it 'returns the configured replacement address' do
        expect(MailSafe::Config.get_replacement_address('you@example.com')).to eq('me@mydomain.com')
      end
    end

    context 'when replacement_address is set to a proc' do
      before(:each) do
        MailSafe::Config.replacement_address = lambda { |address| "me+#{address.split('@').first}@mydomain.com" }
      end

      it 'returns the configured replacement address' do
        expect(MailSafe::Config.get_replacement_address('you@example.com')).to eq('me+you@mydomain.com')
      end
    end

    context 'when replacement_address is not set' do
      before(:each) do
        MailSafe::Config.replacement_address = nil
      end

      context 'and #developer_email_address has a value' do
        before(:each) do
          @developer_address = 'developer@domain.com'
          expect(MailSafe::Config).to receive(:developer_email_address).at_least(1).and_return(@developer_address)
        end

        it 'returns the developer address' do
          expect(MailSafe::Config.get_replacement_address('you@example.com')).to eq(@developer_address)
        end
      end

      context 'and #developer_email_address has no value' do
        before(:each) do
          expect(MailSafe::Config).to receive(:developer_email_address).and_return(nil)
        end

        it 'raises an error' do
          expect { MailSafe::Config.get_replacement_address('you@example.com') }.to raise_error(MailSafe::InvalidConfigSettingError)
        end
      end
    end
  end
end
