require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe MailSafe do
  TEXT_POSTSCRIPT_PHRASE = /The original recipients were:/
  HTML_POSTSCRIPT_PHRASE = /<p>\s+The original recipients were:\s+<\/p>/

  describe 'Delivering a plain text email to internal addresses' do
    before(:each) do
      MailSafe::Config.stub(:is_internal_address?).and_return(true)
      @email = TestMailer.deliver_plain_text_message(:to => 'internal-to@address.com', :bcc => 'internal-bcc@address.com', :cc => 'internal-cc@address.com')
    end

    it 'sends the email to the original addresses' do
      @email.to.should  =~ ['internal-to@address.com']
      @email.cc.should  =~ ['internal-cc@address.com']
      @email.bcc.should =~ ['internal-bcc@address.com']
    end

    it 'does not add a post script to the body' do
       @email.body.should_not =~ TEXT_POSTSCRIPT_PHRASE
    end
  end

  describe 'Delivering a plain text email to external addresses' do
    before(:each) do
      MailSafe::Config.stub(:is_internal_address?).and_return(false)
      MailSafe::Config.stub(:get_replacement_address).and_return('replacement@example.com')
      @email = TestMailer.deliver_plain_text_message(:to => 'internal-to@address.com', :bcc => 'internal-bcc@address.com', :cc => 'internal-cc@address.com')
    end

    it 'sends the email to the replacement address' do
      @email.to.should  =~ ['replacement@example.com'] 
      @email.cc.should  =~ ['replacement@example.com']
      @email.bcc.should =~ ['replacement@example.com']
    end
  end

  def deliver_email_with_mix_of_internal_and_external_addresses(delivery_method)
    MailSafe::Config.internal_address_definition = /internal/
    MailSafe::Config.replacement_address = 'internal@domain.com'
    @email = TestMailer.send(delivery_method,
      {
        :to  => ['internal1@address.com', 'external1@address.com'],
        :cc  => ['internal1@address.com', 'internal2@address.com'],
        :bcc => ['external1@address.com', 'external2@address.com']
      }
    )
  end

  describe 'Delivering a plain text email to a mix of internal and external addresses' do
    before(:each) do
      deliver_email_with_mix_of_internal_and_external_addresses(:deliver_plain_text_message)
    end

    it 'sends the email to the appropriate address' do
      @email.to.should  =~ ['internal1@address.com', 'internal@domain.com']
      @email.cc.should  =~ ['internal1@address.com', 'internal2@address.com']
      @email.bcc.should =~ ['internal@domain.com',   'internal@domain.com']
    end

    it 'adds a plain text post script to the body' do
      @email.body.should =~ TEXT_POSTSCRIPT_PHRASE
    end
  end

  describe 'Delivering an html email to a mix of internal and external addresses' do
    before(:each) do
      deliver_email_with_mix_of_internal_and_external_addresses(:deliver_html_message)
    end

    it 'adds an html post script to the body' do
      @email.body.should =~ HTML_POSTSCRIPT_PHRASE
    end
  end

  describe 'Delivering a multipart email to a mix of internal and external addresses' do
    before(:each) do
      deliver_email_with_mix_of_internal_and_external_addresses(:deliver_multipart_message)
    end

    def part(type)
      @email.parts.detect { |p| p.content_type == type }.body
    end

    it 'adds a text post script to the body of the text part' do
      part('text/plain').should =~ TEXT_POSTSCRIPT_PHRASE
    end

    it 'adds an html post script to the body of the html part' do
      part('text/html').should =~  HTML_POSTSCRIPT_PHRASE
    end
  end
end
