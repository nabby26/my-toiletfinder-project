# -*- encoding: utf-8 -*-
# stub: appengine 0.4.3 ruby lib

Gem::Specification.new do |s|
  s.name = "appengine".freeze
  s.version = "0.4.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Daniel Azuma".freeze]
  s.date = "2017-09-20"
  s.description = "The appengine gem is a set of classes, plugins, and tools for integration with Google App Engine. It provides access to the App Engine runtime environment, including logging to the Google Cloud Console and interrogation of hosting properties. It also provides rake tasks for managing your App Engine application, for example to run production maintenance commands. This gem is not required to deploy your Ruby application to App Engine.".freeze
  s.email = ["dazuma@gmail.com".freeze]
  s.homepage = "https://github.com/GoogleCloudPlatform/appengine-ruby".freeze
  s.licenses = ["Apache 2.0".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0".freeze)
  s.rubygems_version = "2.6.13".freeze
  s.summary = "Google App Engine integration tools".freeze

  s.installed_by_version = "2.6.13" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<google-cloud-env>.freeze, ["~> 1.0"])
      s.add_runtime_dependency(%q<stackdriver>.freeze, ["~> 0.7"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.15"])
      s.add_development_dependency(%q<minitest>.freeze, ["~> 5.0"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 11.0"])
      s.add_development_dependency(%q<rdoc>.freeze, ["~> 4.2"])
      s.add_development_dependency(%q<yard>.freeze, ["~> 0.9"])
    else
      s.add_dependency(%q<google-cloud-env>.freeze, ["~> 1.0"])
      s.add_dependency(%q<stackdriver>.freeze, ["~> 0.7"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.15"])
      s.add_dependency(%q<minitest>.freeze, ["~> 5.0"])
      s.add_dependency(%q<rake>.freeze, ["~> 11.0"])
      s.add_dependency(%q<rdoc>.freeze, ["~> 4.2"])
      s.add_dependency(%q<yard>.freeze, ["~> 0.9"])
    end
  else
    s.add_dependency(%q<google-cloud-env>.freeze, ["~> 1.0"])
    s.add_dependency(%q<stackdriver>.freeze, ["~> 0.7"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.15"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5.0"])
    s.add_dependency(%q<rake>.freeze, ["~> 11.0"])
    s.add_dependency(%q<rdoc>.freeze, ["~> 4.2"])
    s.add_dependency(%q<yard>.freeze, ["~> 0.9"])
  end
end
