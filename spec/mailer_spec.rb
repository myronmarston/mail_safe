require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe MailSafe do
  TEXT_POSTSCRIPT_PHRASE = /The original recipients were:/
  HTML_POSTSCRIPT_PHRASE = /<p>\s+The original recipients were:\s+<\/p>/

  def deliver_message(message_name, *args)
    TestMailer.send(message_name, *args).deliver
  end

  RSpec::Matchers.define :have_addresses do |*expected|
    match do |actual|
      actual.to_a.sort == expected
    end
  end

  describe 'Delivering a plain text email to internal addresses' do
    before(:each) do
      allow(MailSafe::Config).to receive(:is_internal_address?).and_return(true)
      @email = deliver_message(:plain_text_message,
                               :to => 'internal-to@address.com',
                               :bcc => 'internal-bcc@address.com',
                               :cc => 'internal-cc@address.com')
    end

    it 'sends the email to the original addresses' do
      expect(@email.to).to  have_addresses('internal-to@address.com')
      expect(@email.cc).to  have_addresses('internal-cc@address.com')
      expect(@email.bcc).to have_addresses('internal-bcc@address.com')
    end

    it 'does not add a post script to the body' do
       expect(@email.body.to_s).not_to match(TEXT_POSTSCRIPT_PHRASE)
    end
  end

  describe 'Delivering a plain text email to internal addresses with names' do
    before(:each) do
      allow(MailSafe::Config).to receive(:is_internal_address?).and_return(true)
      @email = deliver_message(:plain_text_message,
                               :to => 'Internal To <internal-to@address.com>',
                               :bcc => 'Internal Bcc <internal-bcc@address.com>',
                               :cc => 'Internal Cc <internal-cc@address.com>')
    end

    it 'sends the email to the original addresses' do
      expect(@email[:to].value).to have_addresses('Internal To <internal-to@address.com>')
      expect(@email[:cc].value).to have_addresses('Internal Cc <internal-cc@address.com>')
      expect(@email[:bcc].value).to have_addresses('Internal Bcc <internal-bcc@address.com>')
    end

    it 'does not add a post script to the body' do
      expect(@email.body.to_s).not_to match(TEXT_POSTSCRIPT_PHRASE)
    end
  end

  describe 'Delivering a plain text email to external addresses' do
    before(:each) do
      allow(MailSafe::Config).to receive(:is_internal_address?).and_return(false)
      allow(MailSafe::Config).to receive(:get_replacement_address).and_return('replacement@example.com')
      @email = deliver_message(:plain_text_message, :to => 'external-to@address.com', :bcc => 'external-bcc@address.com', :cc => 'external-cc@address.com')
    end

    it 'sends the email to the replacement address' do
      expect(@email.to).to  have_addresses('replacement@example.com')
      expect(@email.cc).to  have_addresses('replacement@example.com')
      expect(@email.bcc).to have_addresses('replacement@example.com')
    end
  end

  def deliver_email_with_mix_of_internal_and_external_addresses(message_name)
    MailSafe::Config.internal_address_definition = /internal/
    MailSafe::Config.replacement_address = 'internal@domain.com'
    @email = deliver_message(message_name,
      {
        :to  => ['internal1@address.com', 'external1@address.com'],
        :cc  => ['internal1@address.com', 'internal2@address.com'],
        :bcc => ['external1@address.com', 'external2@address.com']
      }
    )
  end

  describe 'Delivering a plain text email to a mix of internal and external addresses' do
    before(:each) do
      deliver_email_with_mix_of_internal_and_external_addresses(:plain_text_message)
    end

    it 'sends the email to the appropriate address' do
      expect(@email.to).to  have_addresses('internal1@address.com', 'internal@domain.com')
      expect(@email.cc).to  have_addresses('internal1@address.com', 'internal2@address.com')
      expect(@email.bcc).to have_addresses('internal@domain.com')
    end

    it 'adds a plain text post script to the body' do
      expect(@email.body.to_s).to match(TEXT_POSTSCRIPT_PHRASE)
    end
  end

  describe 'Delivering an html email to a mix of internal and external addresses' do
    before(:each) do
      deliver_email_with_mix_of_internal_and_external_addresses(:html_message)
    end

    it 'adds an html post script to the body' do
      expect(@email.body.to_s).to match(HTML_POSTSCRIPT_PHRASE)
    end
  end

  describe 'Delivering a multipart email to a mix of internal and external addresses' do
    before(:each) do
      deliver_email_with_mix_of_internal_and_external_addresses(:multipart_message)
    end

    def part(type)
      @email.parts.detect { |p| p.content_type =~ type }.body.to_s
    end

    it 'adds a text post script to the body of the text part' do
      expect(part(/text\/plain/)).to match(TEXT_POSTSCRIPT_PHRASE)
    end

    it 'adds an html post script to the body of the html part' do
      expect(part(/text\/html/)).to match(HTML_POSTSCRIPT_PHRASE)
    end
  end
end
