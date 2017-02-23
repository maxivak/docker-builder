module DockerBuilder
  module Provisioner
    class ProvisionerChef

      attr_accessor :server

      def server=(v)
        @server = v
        @server
      end

      def server
        @server
      end

      def settings
        server
      end


      def initialize(_settings)
        self.server = _settings

      end

      ###

      def copy_config_file
        # config json
        save_config

        # copy to container
        DockerBuilder::Command.cmd %Q(docker cp #{filename_config} #{settings.container_name}:/opt/bootstrap/config.json)

      end

      # helpers
      def save_config
        require 'json'
        filename = filename_config
        FileUtils.mkdir_p(File.dirname(filename))
        File.open(filename,"w+") do |f|
          f.write(build_config.to_json)
        end

        true
      end

      def filename_config
        File.join(Config.root_path, 'temp', "bootstrap-#{settings.name}.json")
      end

      def build_config
        res = {}

        attr = settings.properties['attributes']
        res = attr

        #res = settings.all_attributes

        res
      end

    end
  end
end


