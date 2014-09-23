# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'autoevernote/version'

Gem::Specification.new do |spec|
  spec.name          = "autoevernote"
  spec.version       = AutoEvernote::VERSION
  spec.authors       = ["Adrian Perez"]
  spec.email         = ["adrianperez.deb@gmail.com"]
  spec.description   = %q{A set of recipes for programatically getting stuff into Evernote}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/blackxored/autoevernote"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  # spec.add_dependency "configurations"
  spec.add_dependency "httparty"
  spec.add_dependency "evernote_oauth"
  spec.add_dependency "activesupport", "~> 4.0"
  # TODO: evernote requires thin/rack
  spec.add_dependency "thin"
  spec.add_dependency "mail"
  spec.add_dependency "nokogiri"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock", "~> 1.13.0"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "cane"
end
