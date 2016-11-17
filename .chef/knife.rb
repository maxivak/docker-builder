# settings
local_mode true

#
#log_level                :debug
log_level                :info


#
root = File.absolute_path(File.dirname(__FILE__))
current_dir = File.dirname(__FILE__)

#puts "root=#{root}"

#
my_server_name = ENV["NODE_NAME"] || ENV["SERVER_NAME"]
node_name     my_server_name

#client_key               "#{current_dir}/dummy.pem"
#validation_client_name   "validator"

#p = File.join(root, '../', node_name, 'cookbooks')
#puts "p=#{p}"
#exit

cookbooks_paths = [
    '/mnt/data/projects/mmx/docker-builder/examples/example-nginx/servers/nginx/cookbooks',
    #File.join(root, '../cookbooks'),
    #File.join(root, '../', node_name, 'cookbooks'),
    #'/mnt/data/projects/mmx/chef-repo/cookbooks-common',
    #'/mnt/data/projects/mmx/chef-repo/cookbooks',
]

cookbooks_paths.reject!{|f| !Dir.exists?(f)}

puts "cookbooks: #{cookbooks_paths.inspect}"

cookbook_path cookbooks_paths


# load another knife file
file_knife_custom = File.expand_path("../../examples/example-nginx/servers/#{my_server_name}/.chef/knife.rb", __FILE__)

#puts "f=#{file_knife_custom}"
if ::File.exist?(file_knife_custom)
  #puts "load from file"
  #exit
  #Chef::Config.from_file(file_knife_custom)
end


# ssh
knife[:ssh_attribute] = "knife_zero.host"

# node name
knife[:force] = true

