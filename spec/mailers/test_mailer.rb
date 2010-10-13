class TestMailer < ActionMailer::Base
  # template root must be set for multipart emails, or ActionMailer will throw an exception.
  if ActionMailer::VERSION::MAJOR == 2
    self.template_root = File.dirname(__FILE__)
  end

  def plain_text_message(options)
    setup_recipients(options)
    from       'test@mailsafe.org'
    subject    "Plain text Message Test"
    body       "Here is the message body."
  end

  def html_message(options)
    setup_recipients(options)
    from       'test@mailsafe.org'
    subject    "Html Message Test"
    body       "<p>Here is the message body.</p>"
    content_type 'text/html'

    body(body.html_safe)  if body.respond_to?(:html_safe)
  end

  def multipart_message(options)
    setup_recipients(options)
    from       'test@mailsafe.org'
    subject    "Html Message Test"

    content_type 'multipart/alternative'

    part :content_type => 'text/plain', :body => "Here is the message body."

    html_body = "<p>Here is the message body.</p>"
    html_body = html_body.html_safe  if html_body.respond_to?(:html_safe)
    part :content_type => 'text/html',  :body => html_body
  end

  protected

  def setup_recipients(options)
    recipients options[:to]
    cc         options[:cc]
    bcc        options[:bcc]
  end
end
