# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mail_safe}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Myron Marston"]
  s.date = %q{2009-08-28}
  s.email = %q{myron.marston@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "LICENSE"]
  s.files = ["README.rdoc", "VERSION.yml", "lib/mail_safe", "lib/mail_safe/action_mailer.rb", "lib/mail_safe/address_replacer.rb", "lib/mail_safe/config.rb", "lib/mail_safe.rb", "test/config_test.rb", "test/mailer_test.rb", "test/mailers", "test/mailers/test_mailer.rb", "test/test_helper.rb", "LICENSE"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/myronmarston/mail_safe}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Keep your ActionMailer emails from escaping into the wild during development.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_runtime_dependency(%q<actionmailer>, [">= 0"])
      s.add_development_dependency(%q<Shoulda>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<actionmailer>, [">= 0"])
      s.add_dependency(%q<Shoulda>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<actionmailer>, [">= 0"])
    s.add_dependency(%q<Shoulda>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
  end
end
