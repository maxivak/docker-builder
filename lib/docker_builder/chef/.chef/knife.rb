# settings
local_mode true

#
#log_level                :debug
log_level                :info


#
root = File.absolute_path(File.dirname(__FILE__))
current_dir = File.dirname(__FILE__)

#puts "***** current dir =#{current_dir}"
#puts "***** SERVER root dir =#{ENV['SERVER_PATH']}"
#exit

#
my_server_name = ENV["NODE_NAME"] || ENV["SERVER_NAME"]
node_name     my_server_name

knife[:chef_node_name] = my_server_name

server_base_dir = ENV['SERVER_PATH']
server_cookbooks_path = File.expand_path('cookbooks', ENV['SERVER_PATH'])


#client_key               "#{current_dir}/dummy.pem"
#validation_client_name   "validator"

#p = File.join(root, '../', node_name, 'cookbooks')
#puts "p=#{p}"
#exit

cookbooks_paths = [
    server_cookbooks_path,

    #'/mnt/data/projects/mmx/docker-builder/examples/example-nginx/servers/nginx/cookbooks',
    #File.expand_path('../temp-cookbooks', root),
    #File.join(root, '../cookbooks'),
    #File.join(root, '../', node_name, 'cookbooks'),
    #'/mnt/data/projects/mmx/chef-repo/cookbooks-common',
    #'/mnt/data/projects/mmx/chef-repo/cookbooks',
]

cookbooks_paths.reject!{|f| !Dir.exists?(f)}

#puts "cookbooks: #{cookbooks_paths.inspect}"

cookbook_path cookbooks_paths


# load another knife file
file_knife_custom = File.expand_path(".chef/knife.rb", server_base_dir)
#file_knife_custom = File.expand_path("../../examples/example-nginx/servers/#{my_server_name}/.chef/knife.rb", __FILE__)

#puts "f=#{file_knife_custom}"
if ::File.exist?(file_knife_custom)
  #puts "load from file"
  #exit
  #Chef::Config.from_file(file_knife_custom)
end

# Allow overriding values in this knife.rb
#Chef::Config.from_file(knife_override) if File.exist?(knife_override)


# node name
knife[:force] = true


# ssh
knife[:ssh_attribute] = "knife_zero.host"


#knife[:ssh_user] = 'mmx'
#knife[:ssh_password] = 'pwd'

#knife[:use_sudo] = true

#--no-host-key-verify
knife[:host_key_verify] = false
#--use-sudo-password
#knife[:use_sudo_password] = true



# ssl

ssl_verify_mode  :verify_none




## Attributes of node objects will be saved to json file.
## the automatic_attribute_whitelist option limits the attributes to be saved.
knife[:automatic_attribute_whitelist] = %w[
  fqdn
  os
  os_version
  hostname
  ipaddress
  roles
  recipes
  ipaddress
  platform
  platform_version
  platform_version
  cloud
  cloud_v2
  chef_packages
]
