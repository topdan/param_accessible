# -*- encoding: utf-8 -*-
require File.expand_path('../lib/param_accessible/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Dan Cunning"]
  gem.email         = ["dan@topdan.com"]
  gem.description   = %q{Help secure your controllers from malicious parameters}
  gem.summary       = %q{Help secure your controllers from malicious parameters}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "param_accessible"
  gem.require_paths = ["lib"]
  gem.version       = ParamAccessible::VERSION
  
  gem.add_dependency 'activesupport', '>= 3.0.0'
  gem.add_dependency 'actionpack', '>= 3.0.0'
  gem.add_development_dependency 'rails', '>= 3.0.0'
  gem.add_development_dependency 'rspec-rails'
  gem.add_development_dependency "simplecov"
end
