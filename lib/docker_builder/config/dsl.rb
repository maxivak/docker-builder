# encoding: utf-8

module DockerBuilder
  module Config
    # Context for loading user config.rb and model files.
    class DSL
      #class Error < Backup::Error; end
      #Server = DockerBuilder::Server

      attr_reader :_config_options

      def initialize
        @_config_options = {}
      end

      # Allow users to set command line path options in config.rb
      [:root_path, :tmp_path].each do |name|
        define_method name, lambda {|path| _config_options[name] = path }
      end

      # allowed options
      [:servers, :common, :base].each do |name|
        define_method name, lambda {|v| _config_options[name] = v }
      end



      # Allows users to create preconfigured models.
=begin
        def preconfigure(name, &block)
          unless name.is_a?(String) && name =~ /^[A-Z]/
            raise Error, "Preconfigured model names must be given as a string " +
                "and start with a capital letter."
          end

          if DSL.const_defined?(name)
            raise Error, "'#{ name }' is already in use " +
                "and can not be used for a preconfigured model."
          end

          DSL.const_set(name, Class.new(Model))
          DSL.const_get(name).preconfigure(&block)
        end
=end

    end
  end
end
