base_dir = File.dirname(__FILE__)

#
require 'chef/provisioning'

#
server_name = ENV['SERVER_NAME']


# settings
docker_options = {
    base_image: node['build']['base_image'],
    privileged: true,
    command: node['docker']['command'] || '',
    #ports: settings.docker_ports_array,
    #volumes: settings.docker_volumes_array,
    #links: settings.docker_links_array
}

#puts "image = #{settings.image_name}"
#puts "opt = #{docker_options}"


### docker image
with_driver 'docker'
machine_image node['base']['image_name'] do
  action :destroy
end

