module DockerBuilder
class CLI < Thor

  ##
  # [build]
  #
  #
  desc 'build', 'Build Docker container(s)'

  long_desc <<-EOS.gsub(/^ +/, '')
  Build.
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
    puts "opt from command line: #{options.inspect}"


    warnings = false
    errors = false


    servers = nil
    begin
      # Load the user's +config.rb+ file and all their Servers
      Config.load(options)

      puts "config root: #{Config.root_path}"
      puts "config options: #{Config.options}"
      #puts "config options: common #{Config.options[:common]}"
      #puts "config options: common #{Config.common}"



      # Identify all servers
      if options[:server]
        servers = {options[:server]=>{}}
      else
        # get from config
        servers = Config.options[:servers]
      end

      puts "servers: #{servers.inspect}"

      servers.each do |name, opts|
        server_settings = Manager.load_settings(name, opts)
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


=begin
    until servers.empty?
      model = models.shift
      model.perform!

      case model.exit_status
        when 1
          warnings = true
        when 2
          errors = true
          unless models.empty?
            Logger.info Error.new(<<-EOS)
              Backup will now continue...
              The following triggers will now be processed:
              (#{ models.map {|m| m.trigger }.join(', ') })
            EOS
          end
        when 3
          fatal = true
          unless models.empty?
            Logger.error FatalError.new(<<-EOS)
              Backup will now exit.
              The following triggers will not be processed:
              (#{ models.map {|m| m.trigger }.join(', ') })
            EOS
          end
      end

      model.notifiers.each(&:perform!)
      exit(3) if fatal
      Logger.clear!
    end
=end


    exit(errors ? 2 : 1) if errors || warnings

  end

end
end
