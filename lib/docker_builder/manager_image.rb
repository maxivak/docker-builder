module DockerBuilder
  class ManagerImage

    ###
    def self.build_image(server_name, settings=nil)
      puts "building image for #{server_name}..."
      #puts "settings: #{settings}"
      #puts "debug: #{settings['properties']}"

      #settings = load_settings(server_name)

      t = settings['build']['build_type']
      if t=='' || t=='none'
        #
        puts "no build needed..."

      elsif t.downcase=='dockerfile'
        return build_image_with_dockerfile(settings)
      elsif t=='chef'
        return build_image_with_chef(settings)
      elsif t=='packer'
        return build_image_with_packer(settings)
      end
    end

    def self.build_image_with_dockerfile(settings)
      puts "build image with Dockerfile"

      #cmd %Q(cd #{name} && docker build -t #{settings.image_name} . )
      cmd %Q(docker build -t #{settings.image_name} #{settings.dir_server_root} )

    end

    def self.build_image_with_chef(settings)
      puts "build image with chef"

      # config json
      save_chef_config(settings)

      # check node
      cmd %Q(cd #{Config.root_path} && chef exec knife node show #{settings.chef_node_name} -c #{chef_config_knife_path})


      #cmd %Q(SERVER_NAME=#{settings.name} SERVER_PATH=#{settings.dir_server_root} chef exec chef-client -z -N #{settings.image_name} -j #{settings.filename_config_json} -c #{chef_config_knife_path} #{chef_recipe_path('chef_build_image.rb')} )
      res_recipe = run_chef_recipe(settings, 'chef_build_image.rb')
    end


    def self.build_image_with_packer(settings)
      require_relative '../../lib/docker_builder/builder/packer'

      puts "build image with packer"

      builder = DockerBuilder::Builder::Packer.new(settings)
      builder.build
    end


    def self.destroy_image(server_name, settings={})
      puts "destroying image for server #{server_name}"

      cmd %Q(docker rmi #{settings.image_name} )
      cmd %Q(docker rm -f chef.converge.#{settings.image_name} )

      # delete chef data
      if settings['build']['build_type']=='chef'
        return destroy_image_chef(settings)
      end
    end


    def self.destroy_image_chef(settings)
      puts "destroying image with chef..."

      # config json
      save_chef_config(settings)

      # destroy temp container
      cmd %Q(docker rm -f chef-converge.#{settings.image_name} )

      #
      cmd %Q(cd #{Config.root_path} && chef exec knife node delete #{settings.chef_node_name}  -y -c #{chef_config_knife_path})

      res_recipe = run_chef_recipe(settings, 'chef_destroy_image.rb')

      chef_remove_data(settings)

      # work - before 2016-nov-19
      #cmd %Q(cd #{Config.root_path} && chef exec knife node delete #{settings.chef_node_name}  -y -c #{chef_config_knife_path})

      # clean chef client, node
      #cmd %Q(cd #{Config.root_path} && rm -f #{settings.filename_chef_node_json} )
      #cmd %Q(cd #{Config.root_path} && rm -f #{settings.filename_chef_client_json} )
    end


    ###
    def self.cmd(s)
      Command.cmd(s)
    end

  end
end
