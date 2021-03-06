# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mumukit/service/version'

Gem::Specification.new do |spec|
  spec.name          = 'mumukit-service'
  spec.version       = Mumukit::Service::VERSION
  spec.authors       = ['Franco Leonardo Bulgarelli']
  spec.email         = ['franco@mumki.org']

  spec.summary       = 'Little framework for building stateful mumuki services'
  spec.homepage      = 'https://github.com/mumuki/mumukit-service'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 2'

  spec.add_dependency 'puma'
  spec.add_dependency 'sinatra'
  spec.add_dependency 'sinatra-cross_origin', '~> 0.3.1'
  spec.add_dependency 'mongo', '~> 2.1'
  spec.add_dependency 'bson_ext'
  spec.add_dependency 'mumukit-core', '~> 1.0'
end
