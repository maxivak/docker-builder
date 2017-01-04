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

#client_key               "#{current_dir}/dummy.pem"
#validation_client_name   "validator"

### cookbooks

server_cookbooks_path = File.expand_path('cookbooks', server_base_dir)

cookbooks_paths = [
    server_cookbooks_path,

    #File.expand_path('../temp-cookbooks', root),
    #File.join(root, '../cookbooks'),
    #File.join(root, '../', node_name, 'cookbooks'),

    #'/work/chef-repo/cookbooks-common',
    #'/work/chef-repo/cookbooks',

]

cookbooks_paths.reject!{|f| !Dir.exists?(f)}

#puts "cookbooks: #{cookbooks_paths.inspect}"




# load another knife file
knife_custom_files = []

if server_base_dir
  knife_custom_files = [
      File.expand_path(".chef/knife.rb", server_base_dir),
      File.expand_path("../../.chef/knife.rb", server_base_dir),
  ]
end

#File.expand_path("../../examples/example-nginx/servers/#{my_server_name}/.chef/knife.rb", __FILE__)

knife_custom_files.each do |file_knife_custom|
  if ::File.exist?(file_knife_custom)
    Chef::Config.from_file(file_knife_custom)
  end
end


cookbook_path cookbook_path+cookbooks_paths

#puts "FINAL cookbooks: #{cookbook_path}"

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
