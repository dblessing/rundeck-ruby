# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rundeck/version'

Gem::Specification.new do |spec|
  spec.name          = "rundeck"
  spec.version       = Rundeck::VERSION
  spec.authors       = ["Drew A. Blessing"]
  spec.email         = ["drew.blessing@mac.com"]
  spec.description   = %q{Ruby client for Rundeck API}
  spec.summary       = %q{A ruby wrapper for the Rundeck API}
  spec.homepage      = "https://github.com/dblessing/rundeck"
  spec.license       = "BSD-2-Clause"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "httparty"
  spec.add_runtime_dependency "libxml-ruby"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
end
