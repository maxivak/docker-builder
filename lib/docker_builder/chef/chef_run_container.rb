base_dir = File.dirname(__FILE__)

#
require 'chef/provisioning'

#
server_name = ENV['SERVER_NAME']

# settings
docker_options = {
    base_image: node['base']['image_name'],
    privileged: true,
    command: node['docker']['command'] || '',
    ports: node['docker']['ports'].map{|d| "#{d[0]}:#{d[1]}"},
    volumes: node['docker']['volumes'].map{|d| "#{d[0]}:#{d[1]}"},
    links: node['docker']['links'].map{|d| "#{d[0]}:#{d[1]}"},

}

# more options
docker_options['hostname'] = node['docker']['hostname'] if node['docker']['hostname']


puts "opt = #{docker_options}"
#puts "volumes = #{node['docker']['volumes']}"
#exit

# init volumes
node['docker']['volumes'].each do |d|
  directory "#{d[0]}" do
    recursive true

    action :create

    mode '0775'
    #owner 'root'
    #group 'root'
  end
end



### docker container
with_driver 'docker'
machine node['base']['container_name'] do
  #tag '0.1'

  recipe "#{server_name}::install"

  # attributes
  #node.keys.each do |k|
  #  attribute k, node[k]
  #end

  # attributes
  node['attributes'].keys.each do |k|
    attribute k, node['attributes'][k]
  end


  machine_options docker_options: docker_options

end

