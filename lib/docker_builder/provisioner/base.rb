module DockerBuilder
  module Provisioner
  class Base

    def self.run_provision_scripts_setup(settings)
      #
      setup_scripts = (settings['provision']['setup'] rescue [])
      if setup_scripts
        setup_scripts.each do |script|
          _run_setup_script(settings, script)
        end
      end

    end


    def self.run_provision_scripts_bootstrap(settings)
      #
      bootstrap_scripts = (settings['provision']['bootstrap'] rescue [])
      if bootstrap_scripts
        bootstrap_scripts.each do |script|
          _run_bootstrap_script(settings, script)
        end
      end


=begin
# commented - 2017-02-22

    #
    install_node_script_type = (settings['install']['node']['script_type'] rescue nil)
    install_bootstrap_script = (settings['install']['bootstrap']['script'] rescue nil)

    if install_node_script_type && install_node_script_type=='chef_recipe'
      # run container and provision with chef
      #_run_container_chef(settings)

      # ???
      #_provision_container_chef_recipe(settings)

    elsif install_node_script_type && install_node_script_type=='shell'
      # docker run
      #create_and_run_container(settings)

      # provision with shell script
      run_shell_script_in_container(settings, "install.sh")

    else
      # no script for provision
      #_run_container_docker(settings)

      # docker run
      #create_and_run_container(settings)

    end

    # bootstrap
    if install_bootstrap_script
      #script = settings['install']['bootstrap']['script'] || '/opt/bootstrap/bootstrap.sh'

      # bootstsrap with shell script
      run_bootstrap_shell_script_in_container(settings, install_bootstrap_script)
    end
=end

    end




    ### provision - setup

    def self._run_setup_script(settings, script)
      puts "run script #{script}"

      if script['type']=='shell'
        return _run_setup_script_on_host_shell(settings, script)
      elsif script['type']=='chef'
        return _run_setup_script_on_host_chef(settings, script)
      end

      return nil
    end

    def self._run_setup_script_on_host_shell(settings, script)
      cmd %Q(cd #{settings.dir_server_root} && #{script['script']} )
    end

    def self._run_setup_script_on_host_chef(settings, script)
      raise 'NOT implemented'

      # run script on host machine
      script_name = settings['install']['host']['script'] || 'install_host'

      # check script exists
      #script_path = "#{settings.name}/cookbooks/#{settings.name}/recipes/#{script_name}.rb"
      #f = File.expand_path('.', script_path)

      #if !File.exists?(f)
      #  puts "script not found: #{f}. Skipping"
      #  return false
      #end

      #puts "pwd= #{Dir.pwd}"
      #puts "root = #{Config.root_path}"
      #exit

      #

      return true
    end




    ### provision - bootstrap

    def self._run_bootstrap_script(settings, script)
      puts "run BS script #{script}"

      if script['type']=='shell' && script['run_from']=='host'
        return _run_bootstrap_script_on_host_shell(settings, script)
      elsif script['type']=='shell' && (script['run_from'].nil? || script['run_from']=='')
        _run_bootstrap_script_in_container_shell(settings, script)
      elsif script['type']=='chef'
        _run_bootstrap_script_in_container_chef(settings, script)
      end

      return nil
    end


    def self._run_bootstrap_script_on_host_shell(settings, script)
      cmd %Q(cd #{settings.dir_server_root} && #{script['script']} )

    end


    def self._run_bootstrap_script_in_container_shell(settings, script)
      script_path = script['script']

      # exec
      cmd %Q(docker exec #{settings.container_name} #{script_path} )
    end

    def self._run_bootstrap_script_in_container_chef(settings, script)
      req = DockerBuilder::Provisioner::Chef.new(settings)
      return req.run_recipe_in_container script['dir_base'], script['recipe_name']
    end



    ### helpers - shell

    def self.run_script_in_container_shell(settings, script_name)
      script_path = settings.make_path_full("scripts/#{script_name}")

      # copy
      cmd %Q(cd #{Config.root_path} && docker cp #{script_path} #{settings.container_name}:/tmp/#{script_name} )

      # exec
      cmd %Q(docker exec #{settings.container_name} chmod +x /tmp/#{script_name} )
      cmd %Q(docker exec #{settings.container_name} /tmp/#{script_name} )
    end





    ###
    def self.cmd(s)
      Command.cmd(s)
    end


  end
  end
end

