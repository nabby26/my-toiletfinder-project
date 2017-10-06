# -*- encoding: utf-8 -*-
# stub: google-cloud-debugger 0.28.1 ruby lib
# stub: ext/google/cloud/debugger/debugger_c/extconf.rb

Gem::Specification.new do |s|
  s.name = "google-cloud-debugger".freeze
  s.version = "0.28.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Heng Xiong".freeze]
  s.date = "2017-09-08"
  s.description = "google-cloud-debugger is the official library for Stackdriver Debugger.".freeze
  s.email = ["hexiong@google.com".freeze]
  s.extensions = ["ext/google/cloud/debugger/debugger_c/extconf.rb".freeze]
  s.files = ["ext/google/cloud/debugger/debugger_c/extconf.rb".freeze]
  s.homepage = "https://github.com/GoogleCloudPlatform/google-cloud-ruby/tree/master/google-cloud-debugger".freeze
  s.licenses = ["Apache-2.0".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.2.0".freeze)
  s.rubygems_version = "2.6.13".freeze
  s.summary = "API Client and instrumentation library for Stackdriver Debugger".freeze

  s.installed_by_version = "2.6.13" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<binding_of_caller>.freeze, ["~> 0.7"])
      s.add_runtime_dependency(%q<google-cloud-core>.freeze, ["~> 1.0"])
      s.add_runtime_dependency(%q<google-cloud-logging>.freeze, ["~> 1.0"])
      s.add_runtime_dependency(%q<google-gax>.freeze, ["~> 0.8.0"])
      s.add_runtime_dependency(%q<stackdriver-core>.freeze, ["~> 1.2"])
      s.add_development_dependency(%q<minitest>.freeze, ["~> 5.10"])
      s.add_development_dependency(%q<minitest-autotest>.freeze, ["~> 1.0"])
      s.add_development_dependency(%q<minitest-focus>.freeze, ["~> 1.1"])
      s.add_development_dependency(%q<minitest-rg>.freeze, ["~> 5.2"])
      s.add_development_dependency(%q<autotest-suffix>.freeze, ["~> 1.1"])
      s.add_development_dependency(%q<rubocop>.freeze, ["<= 0.35.1"])
      s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.9"])
      s.add_development_dependency(%q<yard>.freeze, ["~> 0.9"])
      s.add_development_dependency(%q<yard-doctest>.freeze, ["~> 0.1.8"])
      s.add_development_dependency(%q<railties>.freeze, ["~> 4.0"])
      s.add_development_dependency(%q<rack>.freeze, [">= 0.1"])
      s.add_development_dependency(%q<rake-compiler>.freeze, ["~> 1.0"])
    else
      s.add_dependency(%q<binding_of_caller>.freeze, ["~> 0.7"])
      s.add_dependency(%q<google-cloud-core>.freeze, ["~> 1.0"])
      s.add_dependency(%q<google-cloud-logging>.freeze, ["~> 1.0"])
      s.add_dependency(%q<google-gax>.freeze, ["~> 0.8.0"])
      s.add_dependency(%q<stackdriver-core>.freeze, ["~> 1.2"])
      s.add_dependency(%q<minitest>.freeze, ["~> 5.10"])
      s.add_dependency(%q<minitest-autotest>.freeze, ["~> 1.0"])
      s.add_dependency(%q<minitest-focus>.freeze, ["~> 1.1"])
      s.add_dependency(%q<minitest-rg>.freeze, ["~> 5.2"])
      s.add_dependency(%q<autotest-suffix>.freeze, ["~> 1.1"])
      s.add_dependency(%q<rubocop>.freeze, ["<= 0.35.1"])
      s.add_dependency(%q<simplecov>.freeze, ["~> 0.9"])
      s.add_dependency(%q<yard>.freeze, ["~> 0.9"])
      s.add_dependency(%q<yard-doctest>.freeze, ["~> 0.1.8"])
      s.add_dependency(%q<railties>.freeze, ["~> 4.0"])
      s.add_dependency(%q<rack>.freeze, [">= 0.1"])
      s.add_dependency(%q<rake-compiler>.freeze, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<binding_of_caller>.freeze, ["~> 0.7"])
    s.add_dependency(%q<google-cloud-core>.freeze, ["~> 1.0"])
    s.add_dependency(%q<google-cloud-logging>.freeze, ["~> 1.0"])
    s.add_dependency(%q<google-gax>.freeze, ["~> 0.8.0"])
    s.add_dependency(%q<stackdriver-core>.freeze, ["~> 1.2"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5.10"])
    s.add_dependency(%q<minitest-autotest>.freeze, ["~> 1.0"])
    s.add_dependency(%q<minitest-focus>.freeze, ["~> 1.1"])
    s.add_dependency(%q<minitest-rg>.freeze, ["~> 5.2"])
    s.add_dependency(%q<autotest-suffix>.freeze, ["~> 1.1"])
    s.add_dependency(%q<rubocop>.freeze, ["<= 0.35.1"])
    s.add_dependency(%q<simplecov>.freeze, ["~> 0.9"])
    s.add_dependency(%q<yard>.freeze, ["~> 0.9"])
    s.add_dependency(%q<yard-doctest>.freeze, ["~> 0.1.8"])
    s.add_dependency(%q<railties>.freeze, ["~> 4.0"])
    s.add_dependency(%q<rack>.freeze, [">= 0.1"])
    s.add_dependency(%q<rake-compiler>.freeze, ["~> 1.0"])
  end
end
