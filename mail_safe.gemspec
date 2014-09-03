# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mail_safe/version"

Gem::Specification.new do |spec|
  spec.name          = "mail_safe"
  spec.version       = MailSafe::VERSION
  spec.authors       = ["Myron Marston", "Juan José Conti"]
  spec.email         = ["myron.marston@gmail.com", "jjconti@gmail.com"]
  spec.summary       = %q{Keep your ActionMailer emails from escaping into the wild during development.}
  spec.description   = %q{Mail safe provides a safety net while you"re developing an application that uses ActionMailer.
                          It keeps emails from escaping into the wild.

                          Once you"ve installed and configured this gem, you can rest assure that your app won"t send
                          emails to external email addresses. Instead, emails that would normally be delivered to external
                          addresses will be sent to an address of your choosing, and the body of the email will be appended
                          with a note stating where the email was originally intended to go.}
  spec.homepage      = "http://github.com/myronmarston/mail_safe"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "actionmailer", ">= 3.0.0"
  spec.add_dependency "coveralls"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0", ">= 3.0.0"
  spec.add_development_dependency "appraisal"
end
