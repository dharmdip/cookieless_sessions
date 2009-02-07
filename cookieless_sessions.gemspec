# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cookieless_sessions}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Todd Tyree"]
  s.date = %q{2009-02-07}
  s.description = %q{Allow cookieless sessions in Rails.}
  s.email = %q{todd@snappl.co.uk}
  s.extra_rdoc_files = ["lib/cookieless_sessions.rb", "README.rdoc"]
  s.files = ["cookieless_sessions.gemspec", "init.rb", "lib/cookieless_sessions.rb", "Manifest", "Rakefile", "README.rdoc"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/tatyree/cookieless_sessions}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Cookieless_sessions", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{cookieless_sessions}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Allow cookieless sessions in Rails.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
