# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tinysync/version'

Gem::Specification.new do |spec|
  spec.name          = "tinysync"
  spec.version       = TinySync::VERSION
  spec.authors       = ["Andy Selvig"]
  spec.email         = ["ajselvig@gmail.com"]
  spec.description   = "TinySync is a set of libraries to allow automatic data synchronization across multiple platforms."
  spec.summary       = "Ruby server library for TinySync."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "activemodel"
  spec.add_development_dependency "activesupport"
end
