class TestMailer < ActionMailer::Base
  # template root must be set for multipart emails, or ActionMailer will throw an exception.
  if respond_to?(:view_paths)
    view_paths.unshift File.dirname(__FILE__)
  else
    template_root File.dirname(__FILE__)
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
  end

  def multipart_message(options)
    setup_recipients(options)
    from       'test@mailsafe.org'
    subject    "Html Message Test"

    content_type 'multipart/alternative'

    part :content_type => 'text/plain', :body => "Here is the message body."
    part :content_type => 'text/html',  :body => "<p>Here is the message body.</p>"
  end

  protected

  def setup_recipients(options)
    recipients options[:to]
    cc         options[:cc]
    bcc        options[:bcc]
  end
end
