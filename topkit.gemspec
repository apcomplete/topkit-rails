# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'topkit/version'

Gem::Specification.new do |spec|
  spec.name          = "topkit"
  spec.version       = Topkit::VERSION
  spec.authors       = ["Alex Padgett"]
  spec.email         = ["apadgett@topicdesign.com"]
  spec.description   = %q{Generate rails app with Topic gems, frameworks and layouts}
  spec.summary       = %q{Generate a Rails app using Topic Design's conventions.  Influenced heavily by thoughtbot's Suspenders and Gaslight's sparkler.}
  spec.homepage      = "https://github.com/topicdesign/topkit-rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rails", "~> 3.2"
  spec.add_development_dependency "rake"
end
