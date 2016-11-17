base_dir = File.dirname(__FILE__)

puts "dir=#{base_dir}"
puts "node: #{node.inspect}"
exit

#
require_relative '../config'
require_relative '../server_settings'

#
require 'chef/provisioning'

#
server_name = ENV['SERVER_NAME']
settings = DockerBuilder::Settings.load_settings_for_server(server_name)

#a_volumes = (settings.attributes['build']['volumes'] || [])

# settings
docker_options = {
    base_image: settings.attributes['build']['base_image'],
    privileged: true,
    command: settings.attributes['docker']['command'] || '',
    #ports: settings.docker_ports_array,
    #volume: [], # '/var/www/html',
    #volumes: ['/var/www/html'], # ,

    #links: settings.docker_links_array
}

puts "image = #{settings.image_name}"
puts "opt = #{docker_options}"
#exit

### docker image
with_driver 'docker'
machine_image settings.image_name do
  action :create

  recipe "#{server_name}::build"

  # attributes
  node.keys.each do |k|
    attribute k, node[k]
  end

  # attributes
  settings.node.keys.each do |k|
    attribute k, settings.node[k]
  end

  #
  machine_options docker_options: docker_options


end



