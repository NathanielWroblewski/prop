# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'prop/version'
require 'date'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 2.0.0'
  spec.add_dependency 'bundler', '~> 1.3'
  spec.add_dependency 'rails', '4.0.0'
  spec.authors = ['Nathaniel Wroblewski']
  spec.date = Date.today.strftime('%Y-%m-%d')

  spec.description = <<-HERE
Prop is a base Rails project that you can upgrade.
It is used to get a jump start on a working app.
  HERE

  spec.email         = ["nathanielwroblewski@gmail.com"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.name          = "prop"
  spec.summary       = 'Generate a Rails app using pre-configured best practices'
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.version       = Prop::VERSION
end
