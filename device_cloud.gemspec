# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'device_cloud/version'

Gem::Specification.new do |spec|
  spec.name          = 'device_cloud'
  spec.version       = DeviceCloud::VERSION
  spec.authors       = ['Erik Straub']
  spec.email         = ['erik@madgloryint.com']
  spec.description   = %q{A Ruby wrapper for the Etherios Device Cloud}
  spec.summary       = %q{A Ruby wrapper for the Etherios Device Cloud}
  spec.homepage      = 'http://github.com/madgloryint/device_cloud'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'nori', '~> 2.3'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'awesome_print'
end
