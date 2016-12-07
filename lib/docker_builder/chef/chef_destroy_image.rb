base_dir = File.dirname(__FILE__)

#
require 'chef/provisioning'

#
server_name = ENV['SERVER_NAME']


# settings

### docker image
with_driver 'docker'
machine_image node['base']['image_name'] do
  action :destroy
end

