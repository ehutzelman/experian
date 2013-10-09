# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'experian/version'

Gem::Specification.new do |spec|
  spec.name          = "experian"
  spec.version       = Experian::VERSION
  spec.authors       = ["Eric Hutzelman"]
  spec.email         = ["ehutzelman@gmail.com"]
  spec.description   = %q{Gem for interacting with the Experian connect check API}
  spec.summary       = %q{Gem for interacting with the Experian connect check API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "excon"
  spec.add_dependency "builder"
  spec.add_development_dependency "bundler", "~> 1.3"
end
