module DockerBuilder
  class ManagerSwarm

    def self.destroy_service(server_name, settings)
      puts "destroying service #{server_name}..."

      #
      cmd %Q(docker service rm #{settings.container_name} )

      #
      return true
    end


    def self.create_service(server_name, settings={})
      puts "create swarm service.."

      # destroy
      destroy_service(server_name, settings)


      # create service
      docker_opts = settings.attributes['docker']
      puts "ooo: #{docker_opts}"

      run_opts = []
      run_opts << "--network #{docker_opts['swarm_network']}" if docker_opts['swarm_network']
      run_opts << docker_opts['swarm_options']

      cmd %Q(docker service create \
--name #{settings.container_name} #{settings.docker_ports_string} \
#{run_opts.join(' ')} \
#{settings.image_name} #{settings['docker']['command']}
)
    end



    # helpers

    def self.cmd(s)
      Command.cmd(s)
    end


  end
end
