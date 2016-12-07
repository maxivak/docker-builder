base_dir = File.dirname(__FILE__)

#puts "dir=#{base_dir}"

#
require 'chef/provisioning'

#
server_name = ENV['SERVER_NAME']

# settings
docker_options = {
    base_image: node['build']['base_image'],
    privileged: true,
    command: node['docker']['command'] || '',
}

#puts "server: #{server_name}"
#puts "node base = #{node['base']}"
#puts "image = #{node['base']['image_name']}"
#puts "node attr: #{node['attributes']}"
#puts "docker opt = #{docker_options}"
#exit

image_name = node['base']['image_name']
#image_name = 'example-my'

### docker image
with_driver 'docker'
#machine_image node['base']['image_name'] do
machine_image image_name do
  action :create

  #tag '0.1'

  recipe "#{server_name}::build"

  # attributes
  #node.keys.each do |k|
  #  attribute k, node[k]
  #end

  # attributes
  node['attributes'].keys.each do |k|
    attribute k, node['attributes'][k]
  end

  #
  machine_options docker_options: docker_options


end



