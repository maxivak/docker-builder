require "docker_builder/version"

require 'thor'

LIBRARY_PATH = File.join(File.dirname(__FILE__), 'docker_builder')

module DockerBuilder


  ##
  # Require base files
  %w{
    config
    command
    cli
    server_settings
    manager_image
    manager_container
    manager_swarm
    provisioner/base
    provisioner/chef
  }.each {|lib| require File.join(LIBRARY_PATH, lib) }
end
