base_dir = File.dirname(__FILE__)

#puts "dir=#{base_dir}"

#
require 'chef/provisioning'

#
server_name = ENV['SERVER_NAME']
#puts "server: #{server_name}"
#puts "node: #{node['docker'].inspect}"
#exit


# settings
docker_options = {
    base_image: node['build']['base_image'],
    #base_image: 'nginx:1.10',
    privileged: true,
    command: node['docker']['command'] || '',
    #command: "nginx -g 'daemon off;'",
    #command: "",

}

#puts "image = #{settings.image_name}"
#puts "opt = #{docker_options}"
#exit





### docker image
with_driver 'docker'
machine_image node['base']['image_name'] do
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



