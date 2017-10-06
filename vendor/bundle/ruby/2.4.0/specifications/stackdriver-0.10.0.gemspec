# -*- encoding: utf-8 -*-
# stub: stackdriver 0.10.0 ruby lib

Gem::Specification.new do |s|
  s.name = "stackdriver".freeze
  s.version = "0.10.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Heng Xiong".freeze]
  s.date = "2017-09-08"
  s.description = "stackdriver is the official library for Google Stackdriver APIs.".freeze
  s.email = ["hxiong388@gmail.com".freeze]
  s.homepage = "https://github.com/GoogleCloudPlatform/google-cloud-ruby/tree/master/stackdriver".freeze
  s.licenses = ["Apache-2.0".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.2.0".freeze)
  s.rubygems_version = "2.6.13".freeze
  s.summary = "API Client library for Google Stackdriver".freeze

  s.installed_by_version = "2.6.13" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<google-cloud-debugger>.freeze, ["~> 0.28.0"])
      s.add_runtime_dependency(%q<google-cloud-error_reporting>.freeze, ["~> 0.27.0"])
      s.add_runtime_dependency(%q<google-cloud-logging>.freeze, ["~> 1.2"])
      s.add_runtime_dependency(%q<google-cloud-trace>.freeze, ["~> 0.27.0"])
      s.add_development_dependency(%q<minitest>.freeze, ["~> 5.10"])
      s.add_development_dependency(%q<minitest-autotest>.freeze, ["~> 1.0"])
      s.add_development_dependency(%q<minitest-focus>.freeze, ["~> 1.1"])
      s.add_development_dependency(%q<minitest-rg>.freeze, ["~> 5.2"])
      s.add_development_dependency(%q<autotest-suffix>.freeze, ["~> 1.1"])
      s.add_development_dependency(%q<rubocop>.freeze, ["<= 0.35.1"])
      s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.9"])
      s.add_development_dependency(%q<yard>.freeze, ["~> 0.9"])
      s.add_development_dependency(%q<yard-doctest>.freeze, ["~> 0.1.6"])
      s.add_development_dependency(%q<railties>.freeze, ["~> 4.0"])
    else
      s.add_dependency(%q<google-cloud-debugger>.freeze, ["~> 0.28.0"])
      s.add_dependency(%q<google-cloud-error_reporting>.freeze, ["~> 0.27.0"])
      s.add_dependency(%q<google-cloud-logging>.freeze, ["~> 1.2"])
      s.add_dependency(%q<google-cloud-trace>.freeze, ["~> 0.27.0"])
      s.add_dependency(%q<minitest>.freeze, ["~> 5.10"])
      s.add_dependency(%q<minitest-autotest>.freeze, ["~> 1.0"])
      s.add_dependency(%q<minitest-focus>.freeze, ["~> 1.1"])
      s.add_dependency(%q<minitest-rg>.freeze, ["~> 5.2"])
      s.add_dependency(%q<autotest-suffix>.freeze, ["~> 1.1"])
      s.add_dependency(%q<rubocop>.freeze, ["<= 0.35.1"])
      s.add_dependency(%q<simplecov>.freeze, ["~> 0.9"])
      s.add_dependency(%q<yard>.freeze, ["~> 0.9"])
      s.add_dependency(%q<yard-doctest>.freeze, ["~> 0.1.6"])
      s.add_dependency(%q<railties>.freeze, ["~> 4.0"])
    end
  else
    s.add_dependency(%q<google-cloud-debugger>.freeze, ["~> 0.28.0"])
    s.add_dependency(%q<google-cloud-error_reporting>.freeze, ["~> 0.27.0"])
    s.add_dependency(%q<google-cloud-logging>.freeze, ["~> 1.2"])
    s.add_dependency(%q<google-cloud-trace>.freeze, ["~> 0.27.0"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5.10"])
    s.add_dependency(%q<minitest-autotest>.freeze, ["~> 1.0"])
    s.add_dependency(%q<minitest-focus>.freeze, ["~> 1.1"])
    s.add_dependency(%q<minitest-rg>.freeze, ["~> 5.2"])
    s.add_dependency(%q<autotest-suffix>.freeze, ["~> 1.1"])
    s.add_dependency(%q<rubocop>.freeze, ["<= 0.35.1"])
    s.add_dependency(%q<simplecov>.freeze, ["~> 0.9"])
    s.add_dependency(%q<yard>.freeze, ["~> 0.9"])
    s.add_dependency(%q<yard-doctest>.freeze, ["~> 0.1.6"])
    s.add_dependency(%q<railties>.freeze, ["~> 4.0"])
  end
end
