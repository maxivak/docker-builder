# encoding: utf-8
require 'docker_builder/config/dsl'
require 'docker_builder/config/helpers'



module DockerBuilder
  module Config
    #class Error < DockerBuilder::Error; end

    DEFAULTS = {
        :config_file  => 'config.rb',
        :tmp_path     => 'temp'
    }

    class << self
      #include Utilities::Helpers

      attr_reader :servers, :options,
                  :root_path, :config_file, :tmp_path


      # Define on self, since it's  a class method
      def method_missing(method_sym, *arguments, &block)
        # the first argument is a Symbol, so you need to_s it if you want to pattern match
        if options.has_key?(method_sym)
          return options[method_sym]
        else
          super
        end
        #if method_sym.to_s =~ /^find_by_(.*)$/
        #  find($1.to_sym => arguments.first)

      end



      # Loads the user's +config.rb+ and all model files.
      def load(opts = {})
        update(opts)  # from the command line

        #config_file = 'temp_config.rb'

        puts "config file: #{config_file}"

        unless File.exist?(config_file)
          #raise Error, "Could not find configuration file: '#{config_file}'."
          raise "Could not find configuration file: '#{config_file}'."
        end

        text_config = File.read(config_file)

        dsl = DSL.new
        dsl.instance_eval(text_config, config_file)

        # set options from dsl object
        update(dsl._config_options)  # from config.rb
        # command line takes precedence
        update(opts)

        #Dir[File.join(File.dirname(config_file), 'models', '*.rb')].each do |model|
        #  dsl.instance_eval(File.read(model), model)
        #end

        # servers
        #puts "ss = #{@options}"

        #load_servers(opts)
        if @options['server']
          #puts "ONE sevrer"
          srv_name = @options['server'] || @options[:server]
          # one server
          @servers = {srv_name => dsl._config_servers[srv_name]}
        else
          #puts "ALL sevrer"
          # all servers
          @servers = dsl._config_servers
        end


        @servers.each do |name, sc|
          # from common config
          sc.common_config = self
          sc.properties['name'] ||= name
          #sc.properties['common'] = Config.options[:common]
        end

      end


      def dir_gem_root
        return @dir_gem_root unless @dir_gem_root.nil?

        #
        spec = Gem::Specification.find_by_name("docker-builder")
        @dir_gem_root = spec.gem_dir

        @dir_gem_root
      end

      def options
        return @options unless @options.nil?

        @options = {}
        @options
      end

      #def servers
        #options[:servers]
        #@_servers || []
      #end

      def load_servers(opts)
        # Identify all servers
        if opts[:server]
          server_name = opts[:server]
          options[:servers] = {server_name=>options[:servers][server_name] }
        else
          # get from config
          #options[:servers] = options[:servers]
        end


      end


      def self.load_settings_for_server(name, opts={})
        settings = ServerSettings.new

        settings.set 'name', name

        # set from main Config
        Config.servers[name].each do |k,v|
          settings.properties[k]=v
        end


        #puts "current=#{File.dirname(__FILE__)}"
        #puts "ff=#{file_base_settings}"

        #
        #t = File.read(file_base_settings) rescue ''
        #eval(t, settings.get_binding)


        #
        f = file_settings_for_server(name)
        t = File.read(f) rescue ''
        eval(t, settings.get_binding)

        #
        settings.properties['name'] ||= name

        # from common config
        settings.properties['common'] = Config.options[:common]

        settings
      end


      ### helpers

      def self.file_settings_for_server(name)
        #File.join(File.dirname(__FILE__), '..', 'config', "#{name}.rb")
        File.join(Config.root_path, 'servers', name, 'config.rb')
      end

      def self.file_server_base_settings
        File.join(File.dirname(__FILE__), '..', 'config' ,'common.rb')
      end


      private

      # If :root_path is set in the options, all paths will be updated.
      # Otherwise, only the paths given will be updated.
      def update(opts = {})
        #puts "update. opts=#{opts}"

        # root_path
        root_path = opts[:root_path].to_s.strip

        #puts "root from opts = #{root_path}"

        if root_path.empty?
          root_path = File.path(Dir.getwd)
        end

        new_root = root_path.empty? ? false : set_root_path(root_path)

        DEFAULTS.each do |name, ending|
          set_path_variable(name, options[name], ending, new_root)
        end

        # options
        opts.each do |name, v|
          set_variable(name, v)
        end

        # config file
        set_path_variable("config_file", options['config_file'], DEFAULTS['config_file'], new_root)

      end

      # Sets the @root_path to the given +path+ and returns it.
      # Raises an error if the given +path+ does not exist.
      def set_root_path(path)
        # allows #reset! to set the default @root_path,
        # then use #update to set all other paths,
        # without requiring that @root_path exist.
        return @root_path if path == @root_path

        path = File.expand_path(path)

        unless File.directory?(path)
          raise Error, <<-EOS
            Root Path Not Found
            When specifying a --root-path, the path must exist.
            Path was: #{ path }
          EOS
        end
        @root_path = path
      end



      def set_variable(name, v)
        #instance_variable_set(:"@#{name}", v) if v
        options[name] = v
      end

      def set_path_variable(name, path, ending, root_path)
        # strip any trailing '/' in case the user supplied this as part of
        # an absolute path, so we can match it against File.expand_path()
        path = path.to_s.sub(/\/\s*$/, '').lstrip
        new_path = false
        # If no path is given, the variable will not be set/updated
        # unless a root_path was given. In which case the value will
        # be updated with our default ending.
        if path.empty?
          new_path = File.join(root_path, ending) if root_path
        else
          # When a path is given, the variable will be set/updated.
          # If the path is relative, it will be joined with root_path (if given),
          # or expanded relative to PWD.
          new_path = File.expand_path(path)
          unless path == new_path
            new_path = File.join(root_path, path) if root_path
          end
        end
        instance_variable_set(:"@#{name}", new_path) if new_path
      end

      #def reset!
      #  @root_path = File.join(File.expand_path(ENV['HOME'] || ''), 'DockerBuilder')
      #  update(:root_path => @root_path)
      #end
    end

    #reset!  # set defaults on load
  end
end
