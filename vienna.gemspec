lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'vienna/version'

Gem::Specification.new do |spec|
  spec.name          = 'vienna'
  spec.version       = Vienna::VERSION
  spec.authors       = ['Mikael Konutgan']
  spec.email         = ['me@kmikael.com']
  spec.description   = 'Tiny, zero-configuration static file server'
  spec.summary       = 'Tiny, zero-configuration static file server built on top of rack'
  spec.homepage      = 'https://github.com/kmikael/vienna'
  spec.license       = 'MIT'
  
  spec.files         = `git ls-files`.split
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']
  
  spec.add_runtime_dependency 'rack', '~> 2.0'
  
  spec.add_development_dependency 'bundler', '~> 1.0'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'yard', '~> 0.9'
end
