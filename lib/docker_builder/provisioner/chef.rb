module DockerBuilder
  module Provisioner
    class Chef

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
        DockerBuilder::Command.cmd %Q(docker cp #{filename_config} #{settings.container_name}:#{docker_filename_config})

      end

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

      def docker_filename_config
        "/opt/bootstrap/config.json"
      end

      def build_config
        res = {}

        attr = settings.properties['attributes']
        res = attr

        #res = settings.all_attributes

        res
      end


      ### run recipes
      def run_recipe_in_container(dir_base, recipe_name)

        recipe_name ||= "server::bootstrap"

        # generate config
        copy_config_file


        #
        q = %Q(cd #{dir_base} && chef-client -z -j #{docker_filename_config} --override-runlist "recipe[#{recipe_name}]" )

        # exec
        docker_run_cmd q
      end

      ###
      def docker_run_cmd(s)
        DockerBuilder::Command.cmd %Q(docker exec #{settings.container_name} bash -c '#{s}')
      end

    end
  end
end


