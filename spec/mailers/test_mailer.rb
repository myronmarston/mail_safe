class TestMailer < ActionMailer::Base

  def plain_text_message(options)
    setup = setup_recipients(options)
    mail({from: 'test@mailsafe.org',
         subject: "Plain text Message Test"}.update(setup)) do |format|
      format.text { render text: "Here is the message body." }
    end
  end

  def html_message(options)
    setup = setup_recipients(options)
    body = "<p>Here is the message body.</p>"
    body = body.html_safe  if body.respond_to?(:html_safe)
    mail({from: 'test@mailsafe.org',
         subject: "Html Message Test"}.update(setup)) do |format|
      format.html { render text: body }
    end
  end

  def multipart_message(options)
    setup = setup_recipients(options)
    html_body = "<p>Here is the message body.</p>"
    html_body = html_body.html_safe  if html_body.respond_to?(:html_safe)
    mail({from: 'test@mailsafe.org',
         subject: "Html Message Test"}.update(setup)) do |format|
      format.text { render text: "Here is the message body." }
      format.html { render text: html_body }
    end
  end

  protected

  def setup_recipients(options)
    options.select { |k,_| [:to, :cc, :bcc].include? k }
  end
end
