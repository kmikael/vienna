# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vienna/version'

Gem::Specification.new do |spec|
  spec.name          = 'vienna'
  spec.version       = Vienna::VERSION
  spec.authors       = ['Mikael Konutgan']
  spec.email         = ['me@kmikael.com']
  spec.description   = %q{Zero-configuration static file server based on rack}
  spec.summary       = %q{Zero-configuration static file server based on rack}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  
  spec.add_runtime_dependency 'rack', '~> 1.5'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'yard', '~> 0.8'
end
