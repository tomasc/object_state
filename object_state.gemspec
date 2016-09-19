# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'object_state/version'

Gem::Specification.new do |spec|
  spec.name          = 'object_state'
  spec.version       = ObjectState::VERSION
  spec.authors       = ['Tomas Celizna']
  spec.email         = ['tomas.celizna@gmail.com']

  spec.summary       = "Encapsulates object's state, converts from/to params and to cache_key."
  spec.homepage      = 'https://github.com/tomasc/object_state'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activemodel', '>= 4', '<= 5'
  spec.add_dependency 'activesupport', '>= 4', '<= 5'
  spec.add_dependency 'virtus'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-minitest'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'mongoid', '>= 5.0', '< 6'
  spec.add_development_dependency 'rake', '~> 10.0'
end
