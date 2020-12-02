# -*- encoding: utf-8 -*-
# stub: calabash-android 0.9.9 ruby lib

Gem::Specification.new do |s|
  s.name = "calabash-android".freeze
  s.version = "0.9.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jonas Maturana Larsen".freeze]
  s.date = "2019-04-17"
  s.description = "calabash-android drives tests for native  and hybrid Android apps. ".freeze
  s.email = ["jonas@lesspainful.com".freeze]
  s.executables = ["calabash-android".freeze]
  s.files = ["bin/calabash-android".freeze]
  s.homepage = "http://github.com/calabash".freeze
  s.licenses = ["EPL-1.0".freeze]
  s.rubygems_version = "3.1.2".freeze
  s.summary = "Client for calabash-android for automated functional testing on Android".freeze

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<json>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<cucumber>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<slowhandcuke>.freeze, ["~> 0.0.3"])
    s.add_runtime_dependency(%q<rubyzip>.freeze, [">= 1.2", "< 1.3"])
    s.add_runtime_dependency(%q<awesome_print>.freeze, ["~> 1.2"])
    s.add_runtime_dependency(%q<httpclient>.freeze, [">= 2.7.1", "< 3.0"])
    s.add_runtime_dependency(%q<escape>.freeze, ["~> 0.0.4"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 10.3"])
    s.add_development_dependency(%q<yard>.freeze, [">= 0.9.12", "< 1.0"])
    s.add_development_dependency(%q<redcarpet>.freeze, ["~> 3.1"])
    s.add_development_dependency(%q<rspec_junit_formatter>.freeze, [">= 0"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_development_dependency(%q<pry>.freeze, [">= 0"])
    s.add_development_dependency(%q<pry-nav>.freeze, [">= 0"])
    s.add_development_dependency(%q<guard-rspec>.freeze, [">= 0"])
    s.add_development_dependency(%q<guard-bundler>.freeze, [">= 0"])
    s.add_development_dependency(%q<listen>.freeze, ["= 3.0.6"])
    s.add_development_dependency(%q<growl>.freeze, [">= 0"])
    s.add_development_dependency(%q<stub_env>.freeze, [">= 0"])
  else
    s.add_dependency(%q<json>.freeze, [">= 0"])
    s.add_dependency(%q<cucumber>.freeze, [">= 0"])
    s.add_dependency(%q<slowhandcuke>.freeze, ["~> 0.0.3"])
    s.add_dependency(%q<rubyzip>.freeze, [">= 1.2", "< 1.3"])
    s.add_dependency(%q<awesome_print>.freeze, ["~> 1.2"])
    s.add_dependency(%q<httpclient>.freeze, [">= 2.7.1", "< 3.0"])
    s.add_dependency(%q<escape>.freeze, ["~> 0.0.4"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.3"])
    s.add_dependency(%q<yard>.freeze, [">= 0.9.12", "< 1.0"])
    s.add_dependency(%q<redcarpet>.freeze, ["~> 3.1"])
    s.add_dependency(%q<rspec_junit_formatter>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_dependency(%q<pry>.freeze, [">= 0"])
    s.add_dependency(%q<pry-nav>.freeze, [">= 0"])
    s.add_dependency(%q<guard-rspec>.freeze, [">= 0"])
    s.add_dependency(%q<guard-bundler>.freeze, [">= 0"])
    s.add_dependency(%q<listen>.freeze, ["= 3.0.6"])
    s.add_dependency(%q<growl>.freeze, [">= 0"])
    s.add_dependency(%q<stub_env>.freeze, [">= 0"])
  end
end
