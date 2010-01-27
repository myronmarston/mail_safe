require 'test_helper'

class MailerTest < Test::Unit::TestCase
  TEXT_POSTSCRIPT_PHRASE = /The original recipients were:/
  HTML_POSTSCRIPT_PHRASE = /<p>\s+The original recipients were:\s+<\/p>/

  def deliver_message(message_name, *args)
    if ActionMailer::VERSION::MAJOR < 3
      TestMailer.send("deliver_#{message_name}", *args)
    else
      TestMailer.send(message_name, *args).deliver
    end
  end

  context 'Delivering a plain text email to internal addresses' do
    setup do
      MailSafe::Config.stubs(:is_internal_address? => true)
      @email = deliver_message(:plain_text_message, :to => 'internal-to@address.com', :bcc => 'internal-bcc@address.com', :cc => 'internal-cc@address.com')
    end

    should 'send the email to the original addresses' do
      assert_equal ['internal-to@address.com'], @email.to
      assert_equal ['internal-cc@address.com'], @email.cc
      assert_equal ['internal-bcc@address.com'], @email.bcc
    end

    should 'not add a post script to the body' do
      assert_no_match TEXT_POSTSCRIPT_PHRASE, @email.body.to_s
    end
  end

  context 'Delivering a plain text email to external addresses' do
    setup do
      MailSafe::Config.stubs(:is_internal_address? => false, :get_replacement_address => 'replacement@example.com')
      @email = deliver_message(:plain_text_message, :to => 'internal-to@address.com', :bcc => 'internal-bcc@address.com', :cc => 'internal-cc@address.com')
    end

    should 'send the email to the replacement address' do
      assert_equal ['replacement@example.com'], @email.to
      assert_equal ['replacement@example.com'], @email.cc
      assert_equal ['replacement@example.com'], @email.bcc
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

  context 'Delivering a plain text email to a mix of internal and external addresses' do
    setup do
      deliver_email_with_mix_of_internal_and_external_addresses(:plain_text_message)
    end

    should 'send the email to the appropriate address' do
      assert_same_elements ['internal1@address.com', 'internal@domain.com'],   @email.to
      assert_same_elements ['internal1@address.com', 'internal2@address.com'], @email.cc
      assert_same_elements ['internal@domain.com',   'internal@domain.com'],   @email.bcc
    end

    should 'add a plain text post script to the body' do
      assert_match TEXT_POSTSCRIPT_PHRASE, @email.body.to_s
    end
  end

  context 'Delivering an html email to a mix of internal and external addresses' do
    setup do
      deliver_email_with_mix_of_internal_and_external_addresses(:html_message)
    end

    should 'add an html post script to the body' do
      assert_match HTML_POSTSCRIPT_PHRASE, @email.body.to_s
    end
  end

  context 'Delivering a multipart email to a mix of internal and external addresses' do
    setup do
      deliver_email_with_mix_of_internal_and_external_addresses(:multipart_message)
    end

    should 'add an text post script to the body of the text part' do
      assert_match TEXT_POSTSCRIPT_PHRASE, @email.parts.detect { |p| p.content_type == 'text/plain' }.body.to_s
    end

    should 'add an html post script to the body of the html part' do
      assert_match HTML_POSTSCRIPT_PHRASE, @email.parts.detect { |p| p.content_type == 'text/html' }.body.to_s
    end
  end
end
