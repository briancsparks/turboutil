# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'turboutil/version'

Gem::Specification.new do |gem|
  gem.name          = "turboutil"
  gem.version       = Turboutil::VERSION
  gem.authors       = ["Brian C Sparks"]
  gem.email         = ["briancsparks@gmail.com"]
  gem.summary       = %q{Your utility grocs *nix config and command-line best practices and patterns.}
  gem.description   = %q{Your utility grocs *nix config and command-line best practices and patterns.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
