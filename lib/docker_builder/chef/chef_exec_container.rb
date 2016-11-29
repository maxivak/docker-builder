base_dir = File.dirname(__FILE__)

# settings
require_relative 'lib/settings'
#
server_name = ENV['SERVER_NAME']
settings = Settings.load_settings_for_server(server_name)

#
include_recipe 'docker'

docker_exec 'touch_it' do
  container settings.container_name
  command ['touch', '/tmp/2.txt']
end

