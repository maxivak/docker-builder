module DockerBuilder
  module Builder
    class Packer

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

      def build
        # config json
        save_packer_config

        DockerBuilder::Command.cmd %Q(packer build #{filename_config} )

      end

      # helpers
      def save_packer_config
        require 'json'
        filename = filename_config
        FileUtils.mkdir_p(File.dirname(filename))
        File.open(filename,"w+") do |f|
          f.write(build_packer_config.to_json)
        end

        true
      end

      def filename_config
        File.join(Config.root_path, 'temp', "packer-#{settings.name}.json")
      end

      def build_packer_config
        res = {}

        res['variables'] = {}

        res['builders'] = []

        bi = settings.properties['build']['base_image']
        base_image_name = "#{bi['name']}:#{bi['tag']}"
        builder1 = {
            pull: false,
            type: "docker",
            image: base_image_name,
            commit: true
        }

        # changes
        entrypoint = settings.properties['build']['entrypoint']
        if entrypoint
          builder1['changes'] ||= []
          builder1['changes'] << "ENTRYPOINT #{entrypoint}"
        end

        res['builders'] << builder1

        #
        recipe_name = settings['build']['packer']['recipe_name'] || 'build'
        cookbook_paths = settings['build']['packer']['cookbook_paths'] || []
        cookbook_paths << settings.dir_cookbooks

        res["provisioners"] = [
            {
                type: "chef-solo",
                prevent_sudo: true,
                cookbook_paths: cookbook_paths,
                json: settings.properties['attributes'],
                run_list: ["recipe[#{settings.name}::#{recipe_name}]"]
          },
        ]

        # tag image
        res["post-processors"] = [
            {
              repository: "#{settings.image_name}",
              type: "docker-tag"
            }
          ]

        res
      end

    end
  end
end


