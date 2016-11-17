base_dir = File.dirname(__FILE__)

#
require_relative 'lib/settings'

#
require 'chef/provisioning'

#
server_name = ENV['SERVER_NAME']
settings = Settings.load_settings_for_server(server_name)



# settings
docker_options = {
    base_image: settings.attributes['build']['base_image'],
    privileged: true,
    command: settings.attributes['docker']['command'] || '',
    #ports: settings.docker_ports_array,
    #volumes: settings.docker_volumes_array,
    #links: settings.docker_links_array
}

puts "image = #{settings.image_name}"
puts "opt = #{docker_options}"


### docker image
with_driver 'docker'

machine_image settings.image_name do
  action :destroy
end

