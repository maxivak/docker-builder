base_dir = File.dirname(__FILE__)

#
require 'chef/provisioning'

#
server_name = ENV['SERVER_NAME']

#
with_driver 'docker'
machine node['base']['container_name'] do
  action :destroy
end
