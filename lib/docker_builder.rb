require "docker_builder/version"

require 'thor'

LIBRARY_PATH = File.join(File.dirname(__FILE__), 'docker_builder')

module DockerBuilder


  ##
  # Require Backup base files
  %w{
    config
    cli
    server_settings
    manager
  }.each {|lib| require File.join(LIBRARY_PATH, lib) }
end
