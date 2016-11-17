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


server_base_dir = ENV['SERVER_PATH']
server_cookbooks_path = File.expand_path('cookbooks', ENV['SERVER_PATH'])


#client_key               "#{current_dir}/dummy.pem"
#validation_client_name   "validator"

#p = File.join(root, '../', node_name, 'cookbooks')
#puts "p=#{p}"
#exit

cookbooks_paths = [
    server_cookbooks_path,
    #File.join(root, '../cookbooks'),
    #File.join(root, '../', node_name, 'cookbooks'),
    #'/mnt/data/projects/mmx/chef-repo/cookbooks-common',
    #'/mnt/data/projects/mmx/chef-repo/cookbooks',
]

cookbooks_paths.reject!{|f| !Dir.exists?(f)}

puts "cookbooks: #{cookbooks_paths.inspect}"

cookbook_path cookbooks_paths


# load another knife file
file_knife_custom = File.expand_path(".chef/knife.rb", server_base_dir)

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

