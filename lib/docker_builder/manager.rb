module DockerBuilder
class Manager


  def self.load_settings(server_name, opts={})
    settings = Settings.load_settings_for_server(server_name, opts)

    settings.set 'name', server_name

    settings
  end

  def self.generate_chef_config(settings)
    filename = settings.file_chef_config

    require 'json'
    File.open(filename,"w+") do |f|
      f.write(settings.node.to_json)
    end

    true
  end


  ###
  def self.build_image(server_name, settings=nil)


    puts "building image for #{server_name}..."
    #puts "settings: #{settings}"
    #puts "debug: #{settings['attributes']}"

    #settings = load_settings(server_name)

    if settings['build']['build_type']=='dockerfile'
      return build_image_with_dockerfile(settings)
    elsif settings['build']['build_type']=='chef'
      return build_image_with_chef(settings)
    end
  end

  def self.build_image_with_dockerfile(settings)
    puts "build image with Dockerfile. Image: #{settings.image_name}"

    name = settings['name']

    cmd %Q(cd #{name} && docker build -t #{settings.image_name} . )

  end

  def self.build_image_with_chef(settings)
    puts "build image with chef 1"

    cmd %Q(SERVER_NAME=#{settings.name} chef-client -z -N #{settings.name} lib/chef/chef_build_image.rb )
  end





  def self.run_container(server_name)
    settings = load_settings(server_name)

    # generate json config for chef
    generate_chef_config(settings)

    # provision host before running container
    res_install = _install_container_provision_host(settings)

    # run container
    res_run = _run_container(settings)


    # TODO: systemd service
    #res_service = _install_service_container(settings)


  end

  def self._install_container_provision_host(settings)
    script_type = (settings['install']['host']['script_type'] rescue nil)
    return true unless script_type

    # run provision script on the host machine
    if script_type=='chef_recipe'
      return _install_container_provision_host_chef_recipe(settings)
    else
      # do nothing
    end

    true
  end


  #
  def self._install_container_provision_host_chef_recipe(settings)
    # run script on host machine
    script_name = settings['install']['host']['script'] || 'install_host'

    # check script exists
    script_path = "#{settings.name}/cookbooks/#{settings.name}/recipes/#{script_name}.rb"
    f = File.expand_path('.', script_path)

    if !File.exists?(f)
      puts "script not found: #{f}. Skipping"
      return false
    end
    #puts "pwd= #{Dir.pwd}"
    #puts "script install = #{script_path}"

    #
    cmd %Q(SERVER_NAME=#{settings.name} chef-client -z -N #{settings.name} --override-runlist 'recipe[#{settings.name}::#{script_name}]' )

    return true
  end

  # run
  def self._run_container(settings)
    puts "run container ..."

    script_type = (settings['install']['node']['script_type'] rescue nil)

    if script_type && script_type=='chef_recipe'
      # run container and provision with chef
      _run_container_chef(settings)

      # ???
      #_provision_container_chef_recipe(settings)
    else
      #_run_container_docker(settings)

      # docker run
      cmd %Q(docker run -d --name #{settings.container_name} #{settings.docker_ports_string} #{settings.docker_volumes_string} #{settings.docker_volumes_from_string} #{settings.docker_links_string} #{settings.run_env_variables_string} #{settings.image_name} #{settings['docker']['command']} #{settings['docker']['run_options']})

    end


    # fix hosts
    #puts "adding hosts..."
    #puts "a= #{settings.attributes}"

    container_hosts = settings.node['hosts'] || []
    container_hosts.each do |r|
      cmd %Q(docker exec #{settings.container_name} bash -c 'echo "#{r[0]} #{r[1]}" >>  /etc/hosts')
    end


    true
  end


  ### systemd service

  def self._install_service_container(settings)
    # not work
    #cmd %Q(SERVER_NAME=#{settings.name} chef-client -z -N #{settings.name} install_container_service.rb )

    # work
    #cmd %Q(SERVER_NAME=#{settings.name} chef-client -z -N #{settings.name} -j config_run_install_container_service.json )

    # work
    #cmd %Q(SERVER_NAME=#{settings.name} chef-client -z -N #{settings.name} --override-runlist 'recipe[server-api::install_container_service]' )

    #
    cmd %Q(SERVER_NAME=#{settings.name} chef-client -z -N #{settings.name} -j config/config-#{settings.name}.json --override-runlist 'recipe[server-api::install_container_service]' )
  end


  def self._remove_service_container(settings)
    cmd %Q(SERVER_NAME=#{settings.name} chef-client -z -N #{settings.name} -j config/config-#{settings.name}.json --override-runlist 'recipe[server-api::remove_container_service]' )
  end


  ### provision

  def self._provision_container_chef_recipe(settings)
    puts "provisioning container #{settings.container_name}"

    #cmd %Q(SERVER_NAME=#{settings.name} chef-client -z -N #{settings.name} #{settings.name}/cookbooks/#{settings.name}/ )
  end

=begin

  def self._run_container_docker(settings)

  end
=end

  def self._run_container_chef(settings)
    # generate config.json for chef


    # run chef
    #s_run = %Q(cd #{settings.name} && chef-client -z -j config.json -c ../.chef/knife.rb -N #{settings.name} ../lib/chef_container_run.rb)
    #s_run = %Q(cd #{settings.name} && SERVER_NAME=#{settings.name} chef-client -z -j  config.common.json -N #{settings.name} ../container.rb)
    #s_run = %Q(cd #{settings.name} && SERVER_NAME=#{settings.name} chef-client -z -N #{settings.name} ../container.rb)

    s_run = %Q(SERVER_NAME=#{settings.name} chef-client -z -N #{settings.name} chef_run_container.rb)

    cmd s_run
  end


  def self.destroy_image(server_name)
    settings = load_settings(server_name)

    return _destroy_image(settings)
  end

  def self._destroy_image(settings)
    cmd %Q(docker rmi #{settings.image_name} )

    # delete chef data
    if settings['build']['build_type']=='chef'
      return destroy_image_chef(settings)
    end
  end


  def self.destroy_image_chef(settings)
    cmd %Q(SERVER_NAME=#{settings.name} knife node delete #{settings.name}  -y)
    cmd %Q(SERVER_NAME=#{settings.name} chef-client -z -N #{settings.name} chef_destroy_image.rb)
    cmd %Q(SERVER_NAME=#{settings.name} knife node delete #{settings.name}  -y)

  end

  ###


  def self.destroy_container(server_name)
   puts "destroy container #{server_name}"

   settings = load_settings(server_name)

   # TODO: stop, remove systemd service
   #res_service = _remove_service_container(settings)

   #
   cmd %Q(docker rm -f #{settings.container_name} )


   # if chef
   if settings['build']['build_type']=='chef'
     return destroy_container_chef(settings)
   end

   #
   return true
 end


  def self.destroy_container_chef(settings)
    cmd %Q(SERVER_NAME=#{settings.name} knife node delete #{settings.name}  -y)
    # knife client delete --yes NODENAME

    cmd %Q(SERVER_NAME=#{settings.name} chef-client -z -N #{settings.name} chef_destroy_container.rb)

  end


  def self.start_container(server_name)
    settings = load_settings(server_name)

    #
    cmd %Q(docker start #{settings.container_name} )

    return true
  end

  ### run task on running container
  def self.exec_task(server_name, recipe_name)
    #raise 'not implemented'

    settings = load_settings(server_name)

    # check script exists
    script_path = "#{settings.name}/cookbooks/#{settings.name}/recipes/#{recipe_name}.rb"
    f = File.expand_path('.', script_path)

    if !File.exists?(f)
      puts "script not found: #{f}. Skipping"
      return false
    end

    #
    cmd %Q(SERVER_NAME=#{settings.name} chef-client -z --override-runlist 'recipe[server-api::exec_container]' )
    #cmd %Q(SERVER_NAME=#{settings.name} chef-client -z -N #{settings.name} --override-runlist 'recipe[#{settings.name}::#{recipe_name}]' )
    #cmd %Q(SERVER_NAME=#{settings.name} chef-client -z -N #{settings.name} chef_exec_container.rb )

    return true
  end

  ###

  def self.cmd(s)
    puts "running: #{s}"
    res = `#{s}`

    puts "#{res}"
  end
end
end
