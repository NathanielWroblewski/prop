# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
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
  spec.executables   = `git ls-files -- bin/*`.split("\n").map { |file| File.basename(file) }
  spec.extra_rdoc_files = %w[README.md LICENSE]
  spec.name          = "prop"
  spec.summary       = 'Generate a Rails app using pre-configured best practices'
  spec.homepage      = 'https://github.com/NathanielWroblewski/prop'
  spec.license       = "MIT"

  spec.files            = `git ls-files`.split("\n")
  spec.rdoc_options     = ['--charset=UTF-8']
  spec.require_paths    = ['lib']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.version       = Prop::VERSION
end
