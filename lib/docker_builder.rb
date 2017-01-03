require "docker_builder/version"

require 'thor'

LIBRARY_PATH = File.join(File.dirname(__FILE__), 'docker_builder')

module DockerBuilder


  ##
  # Require Backup base files
  %w{
    config
    command
    cli
    server_settings
    manager
    manager_swarm
  }.each {|lib| require File.join(LIBRARY_PATH, lib) }
end
