# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'docker_builder/version'
#require File.expand_path('lib/docker_builder/version')


Gem::Specification.new do |spec|
  spec.name          = "docker-builder"
  spec.version       = DockerBuilder::VERSION
  spec.authors       = ["Max Ivak"]
  spec.email         = ["max.ivak@galacticexchange.io"]

  spec.summary       = 'Docker builder'
  spec.description   = "Build Docker containers with Chef, Dockerfile and other tools"
  spec.homepage      = "https://github.com/maxivak/docker-builder"
  spec.license       = "MIT"



  #spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"

  #s.add_dependency 'httparty'
  #s.add_dependency 'json'


  #spec.add_dependency 'ostruct'
  spec.add_dependency 'thor'
end
