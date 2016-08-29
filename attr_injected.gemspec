# frozen_string_literal: true
$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "attr_injected/identity"

Gem::Specification.new do |spec|
  spec.name = AttrInjected::Identity.name
  spec.version = AttrInjected::Identity.version
  spec.platform = Gem::Platform::RUBY
  spec.authors = ["Brandon Croft"]
  spec.email = ["brandon.croft@gmail.com"]
  spec.homepage = "https://github.com/brandonc/attr_injected"
  spec.summary = "Yet another way to inject dependencies in ruby classes"
  spec.description = "Simplifies boilerplate code when defining dependencies in initializer arguments"
  spec.license = "MIT"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rspec", "~> 3.4"
  spec.add_development_dependency "rb-fsevent" # Guard file events for OSX.
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "terminal-notifier"
  spec.add_development_dependency "terminal-notifier-guard"
  spec.add_development_dependency "rubocop", "~> 0.40"

  spec.files = Dir["lib/**/*"]
  spec.extra_rdoc_files = Dir["README*", "CHANGELOG*"]
  spec.require_paths = ["lib"]
end
