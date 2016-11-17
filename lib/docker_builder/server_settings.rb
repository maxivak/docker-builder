module DockerBuilder

class ServerSettings
  attr_accessor :attributes

  def get_binding
    return binding()
  end

  def attributes
    @attributes ||= {}
    @attributes
  end


  def all_attributes
    res = attributes

    res['base'] = {
        'image_name'=> image_name,

    }

    res
  end


  #
  def node
    res = attributes['attributes'] || {}

    res['name'] = name
    res['container_name'] = container_name

    res
  end

  #
  def set(name, v)
    attributes[name] = v
  end

  def add(name, v)
    attributes[name] = {} if attributes[name].nil?

    attributes[name].merge!(v)
  end

  ###
  def prefix
    attributes['common']['prefix']
  end


  ###

  def name
    attributes['name']
  end



  def image_name
    s = attributes['name']

    "#{attributes['common']['image_prefix']}#{s}"
  end

  def container_name(name=nil)
    name ||= attributes['name']
    s = name

    "#{attributes['common']['prefix']}#{s}"
  end

  def chef_node_name
    "#{attributes['common']['prefix']}#{name}"
  end

  def volume_path_local(v)
    res = v.to_s

    if v =~ /^\./
      s = v.gsub /^\.\//, ''

      res = "$PWD/#{self.name}/#{s}"

    elsif v =~ /^\/\//
      res = self.attributes['common']['dir_data']+(v.gsub /^\/\//, '')
    elsif v =~ /^\//
      res = v
    else
      res = self.dir_data+v
    end

    res
  end

  def dir_data
    "#{attributes['common']['dir_data']}#{self.name}/"
  end


  ###
  def docker_volumes
    a = attributes['docker']['volumes'] || []

    # fix paths
    res = a.map do |r|
      path_local = volume_path_local(r[0])

      [path_local, r[1]]
    end

    res
  end

  def docker_volumes_string
    docker_volumes.map{|r| "-v #{r[0]}:#{r[1]}"}.join(' ')
  end

  def docker_volumes_array
    docker_volumes.map{|d| "#{d[0]}:#{d[1]}"}
  end

  ###

  def docker_volumes_from
    a = attributes['docker']['volumes_from'] || []

    # fix paths
    res = a.map do |r|
      "#{prefix}#{r}"
    end

    res
  end

  def docker_volumes_from_string
    docker_volumes_from.map{|d| "--volumes-from #{d}"}.join(' ')
  end

  def docker_volumes_from_array
    docker_volumes_from.map{|d| "#{d}"}
  end

  ###
  def docker_ports
    a = attributes['docker']['ports'] || []
    a
  end

  def docker_ports_string
    docker_ports.map{|r| "-p #{r[0]}:#{r[1]}"}.join(' ')
  end

  def docker_ports_array
    docker_ports.map{|d| "#{d[0]}:#{d[1]}"}
  end

  ###
  def docker_links
    a = attributes['docker']['links'] || []

    # fix
    res = a.map do |r|
      ["#{attributes['common']['prefix']}#{r[0]}", r[1]]
    end

    res
  end

  def docker_links_string
    docker_links.map{|r| "--link #{r[0]}:#{r[1]}"}.join(' ')
  end

  def docker_links_array
    docker_links.map{|d| "#{d[0]}:#{d[1]}"}
  end

  ###

  def run_env_variables
    a = attributes['docker']['run_env'] || []

    a
  end

  def run_env_variables_string
    run_env_variables.map{|r| "-e #{r[0]}=#{r[1]}"}.join(' ')
  end


  ###
  def [](key)
    attributes[key]
  end


  ###
  def file_chef_config
    File.join(File.dirname(__FILE__), '..', 'config' ,"config-#{name}.json")
  end

  def filename_config_json
    File.join(Config.root_path, 'temp', "#{name}.json")
  end

  def dir_cookbooks
    File.expand_path("servers/#{name}/cookbooks", Config.root_path)
  end

  def dir_server_root
    File.expand_path("servers/#{name}", Config.root_path)
  end

  def filename_chef_node_json
    File.expand_path("nodes/#{image_name}.json", dir_server_root)
  end
  def filename_chef_client_json
    File.expand_path("clients/#{image_name}.json", dir_server_root)
  end


end



class Settings

  def self.load_settings_for_server(name, opts={})
    settings = ServerSettings.new


    #puts "current=#{File.dirname(__FILE__)}"
    #puts "ff=#{file_base_settings}"

    #
    #t = File.read(file_base_settings) rescue ''
    #eval(t, settings.get_binding)


    #
    f = file_settings_for_server(name)
    puts "loading server settings from #{f}"
    t = File.read(f) rescue ''
    eval(t, settings.get_binding)

    #
    settings.attributes['name'] ||= name

    # from common config
    settings.attributes['common'] = Config.options[:common]

    #puts "config options  = #{Config.options}"
    #puts "settings000 = #{settings.attributes}"
    #exit

    settings
  end


  def self.save_settings_json(name, settings)
    filename = file_settings_temp_json(name)

    require 'json'
    File.open(filename,"w+") do |f|
      f.write(settings.all_attributes.to_json)
    end


    true
  end

  ### helpers

  def self.file_settings_for_server(name)
    #File.join(File.dirname(__FILE__), '..', 'config', "#{name}.rb")
    File.join(Config.root_path, 'servers', name, 'config.rb')
  end

  def self.file_base_settings
    File.join(File.dirname(__FILE__), '..', 'config' ,'common.rb')
  end

  def self.file_settings_temp_json(name)
    File.join(Config.root_path, 'temp', "#{name}.json")
  end


end
end
