module DockerBuilder
class CLI < Thor

  ##
  # [build]
  #
  #
  desc 'build', 'Build Docker image'

  long_desc <<-EOS.gsub(/^ +/, '')
  Build Docker image.
  EOS

  method_option :server,
                :aliases  => ['-s', '--server'],
                :required => false,
                :type     => :string,
                :desc     => "Server name"

  method_option :root_path,
                :aliases  => '-r',
                :type     => :string,
                :default  => '',
                :desc     => 'Root path to base all relative path on.'

  method_option :config_file,
                :aliases  => '-c',
                :type     => :string,
                :default  => '',
                :desc     => 'Path to your config.rb file.'

  def build
    puts "building..."

    opts = options
    #puts "opt from command line: #{options.inspect}"


    warnings = false
    errors = false


    servers = nil
    begin
      Config.load(options)



      Config.servers.each do |name, opts|
        server_settings = Manager.load_settings(name, opts)

        Settings.save_settings_json(name, server_settings)

        Manager.destroy_image(name, server_settings)
        Manager.build_image(name, server_settings)
      end


      #servers = options[:server].split(',').map(&:strip)
      #models = triggers.map {|trigger|
      #  Model.find_by_trigger(trigger)
      #}.flatten.uniq

      #raise Error, "No servers found " + "'#{ triggers.join(',') }'." if models.empty?

      # Finalize Logger and begin real-time logging.
      #Logger.start!

    rescue Exception => err
      #Logger.error Error.wrap(err)
      #unless Helpers.is_backup_error? err
      #  Logger.error err.backtrace.join("\n")
      #end

      # Logger configuration will be ignored
      # and messages will be output to the console only.
      #Logger.abort!

      puts "exception: #{err.inspect}"
      raise err
      exit(3)
    end

    exit(errors ? 2 : 1) if errors || warnings

  end


  ##
  # [destroy_image]
  #
  #
  desc 'destroy_image', 'Destroy Docker image'

  long_desc <<-EOS.gsub(/^ +/, '')
  Destroy Docker image.
  EOS

  method_option :server,
                :aliases  => ['-s', '--server'],
                :required => false,
                :type     => :string,
                :desc     => "Server name"

  method_option :root_path,
                :aliases  => '-r',
                :type     => :string,
                :default  => '',
                :desc     => 'Root path to base all relative path on.'

  method_option :config_file,
                :aliases  => '-c',
                :type     => :string,
                :default  => '',
                :desc     => 'Path to your config.rb file.'

  def destroy_image
    puts "destroying image..."

    warnings = false
    errors = false

    begin
      Config.load(options)

      puts "root: #{Config.root_path}"

      #puts "servers: #{Config.servers.inspect}"

      Config.servers.each do |name, opts|
        server_settings = Manager.load_settings(name, opts)

        Settings.save_settings_json(name, server_settings)

        Manager.destroy_image(name, server_settings)
      end

      #raise Error, "No servers found " + "'#{ triggers.join(',') }'." if models.empty?

    rescue Exception => err
      puts "exception: #{err.inspect}"
      raise err
      exit(3)
    end

    exit(errors ? 2 : 1) if errors || warnings

  end


  ### helpers




end
end
