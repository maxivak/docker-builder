module DockerBuilder
class CLI < Thor
  include Thor::Actions

  def self.source_root
    #File.dirname(__FILE__)
    File.expand_path('../../templates', __FILE__)
  end


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
    puts "opt from command line: #{options.inspect}"


    warnings = false
    errors = false


    servers = nil
    begin
      Config.load(options)

      #puts "config servers: #{Config.inspect}"
      #puts "config: #{Config.options.inspect}"
      #exit

      Config.servers.each do |name, opts|
        server_settings = Settings.load_settings_for_server(name)

        #puts "s: #{server_settings.inspect}"
        #exit

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
      puts "config: #{Config.inspect}"

      Config.servers.each do |name, opts|
        server_settings = Settings.load_settings_for_server(name)

        puts "s: #{server_settings.inspect}"
        exit

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


  ##
  # [up]
  #
  #
  desc 'up', 'Run Docker container'

  long_desc <<-EOS.gsub(/^ +/, '')
  Run Docker container.
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

  def up
    puts "running..."

    opts = options

    warnings = false
    errors = false


    servers = nil
    begin
      Config.load(options)

      Config.servers.each do |name, opts|
        server_settings = Settings.load_settings_for_server(name)

        Manager.destroy_container(name, server_settings)
        Manager.run_container(name, server_settings)
      end

    rescue Exception => err
      puts "exception: #{err.inspect}"
      raise err
      exit(3)
    end

    exit(errors ? 2 : 1) if errors || warnings

  end



  ##
  # [destroy]
  #
  #
  desc 'destroy', 'Destroy Docker container'

  long_desc <<-EOS.gsub(/^ +/, '')
  Destroy Docker container.
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

  def destroy
    puts "destroying..."

    opts = options

    warnings = false
    errors = false


    servers = nil
    begin
      Config.load(options)

      Config.servers.each do |name, opts|
        server_settings = Settings.load_settings_for_server(name)

        Manager.destroy_container(name, server_settings)
      end

    rescue Exception => err
      puts "exception: #{err.inspect}"
      raise err
      exit(3)
    end

    exit(errors ? 2 : 1) if errors || warnings

  end




  ##
  # [stop]
  #
  #
  desc 'stop', 'Stop Docker container(s)'

  long_desc <<-EOS.gsub(/^ +/, '')
  Stop containers.
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

  def stop
    puts "stopping..."

    opts = options

    warnings = false
    errors = false


    servers = nil
    begin
      Config.load(options)

      Config.servers.each do |name, opts|
        server_settings = Settings.load_settings_for_server(name)

        Manager.stop_container(name, server_settings)
      end

    rescue Exception => err
      puts "exception: #{err.inspect}"
      raise err
      exit(3)
    end

    exit(errors ? 2 : 1) if errors || warnings

  end

  ### generators

  ##
  # [generate new project]
  #
  #
  desc 'generate', 'Generate new project'

  long_desc <<-EOS.gsub(/^ +/, '')
  Generate new project
  EOS

  method_option :name,
                :aliases  => ['-n', '--name'],
                :required => false,
                :type     => :string,
                :desc     => "Project name"


  method_option :type,
                :aliases  => ['-t', '--type'],
                :required => false,
                :type     => :string,
                :default => 'chef',
                :desc     => "Provision type"

  def generate
    puts "creating project..."

    puts "opts: #{options}"
    name = options[:name]
    @name = name

    empty_directory(name)

    if options[:type] == 'chef'
      source_base_dir = "example-chef"

      empty_directory("#{name}/servers")
      template "#{source_base_dir}/config.rb.erb", "#{name}/config.rb"


      # server
      source_server_dir = "#{source_base_dir}/servers/server1"
      server_dir = "#{name}/servers/#{name}"

      directory("#{source_base_dir}/servers/server1/.chef", "#{server_dir}/.chef")


      # cookbooks
      empty_directory("#{server_dir}/cookbooks")
      empty_directory("#{server_dir}/cookbooks/#{name}")
      empty_directory("#{server_dir}/cookbooks/#{name}/recipes")
      empty_directory("#{server_dir}/cookbooks/#{name}/templates")

      template "#{source_server_dir}/config.rb.erb", "#{server_dir}/config.rb"
      template "#{source_server_dir}/cookbooks/server1/metadata.rb.erb", "#{server_dir}/cookbooks/#{name}/metadata.rb"

      directory("#{source_base_dir}/servers/server1/cookbooks/server1/recipes", "#{server_dir}/cookbooks/#{name}/recipes")
      directory("#{source_base_dir}/servers/server1/cookbooks/server1/templates", "#{server_dir}/cookbooks/#{name}/templates")
      copy_file("#{source_base_dir}/servers/server1/cookbooks/server1/README.md", "#{server_dir}/cookbooks/#{name}/README.md")


    end



  end


  ### helpers




end
end
