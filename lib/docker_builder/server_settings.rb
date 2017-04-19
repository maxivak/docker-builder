module DockerBuilder

class ServerSettings
  attr_accessor :properties

  def get_binding
    return binding()
  end

  def properties
    @properties ||= {}
    @properties
  end


  def all_attributes
    res = properties.clone

    res['base'] = {
        'image_name'=> image_name,
        'container_name'=> container_name,

    }

    # docker
    res['docker']['ports'] = docker_ports
    res['docker']['volumes'] = docker_volumes
    res['docker']['links'] = docker_links

    res
  end


  #
  def node
    res = properties['attributes'] || {}

    res['name'] = name
    res['container_name'] = container_name

    res
  end

  ### DSL
  def set(name, v)
    properties[name] = v
  end

  def add(name, v)
    properties[name] = {} if properties[name].nil?

    properties[name].merge!(v)
  end


  def add_config(a)
    # merge
    build(a['build']) if a['build']
    provision(a['provision']) if a['provision']
    docker(a['docker']) if a['docker']
    attributes(a['attributes']) if a['attributes']


  end

  def build(v)
    properties['build'] = v
  end

  def provision(v)
    properties['provision'] = v
  end

  def docker(a)
    # merge
    properties['docker'] ||= {}

    a.each do |k,v|
      properties['docker'][k] = v
    end
  end

  def attributes(a)
    # merge
    properties['attributes'] ||= {}

    a.each do |k,v|
      properties['attributes'][k] = v
    end
  end


  ###
  def prefix
    properties['common']['prefix']
  end

  def container_prefix
    "#{properties['common']['prefix']}#{properties['common']['container_prefix']}"
  end

  def image_prefix
    "#{properties['common']['prefix']}#{properties['common']['image_prefix']}"
  end

  def service_prefix
    "#{properties['common']['prefix']}#{properties['common']['service_prefix']}"
  end


  ###

  def name
    properties['name']
  end



  def image_name
    if !need_build?
      bi = properties['build']['base_image']
      return "#{bi['name']}:#{bi['tag']}"
    end

    #
    s = properties['name']

    if properties['build']['image_name']
      s = "#{properties['build']['image_name']}"
    end

    "#{image_prefix}#{s}"
  end

  def need_build?
    build_type = properties['build']['build_type']
    return false if build_type=='' || build_type=='none'


    true
  end

  def container_name(name=nil)
    name ||= properties['name']
    s = name

    "#{container_prefix}#{s}"
  end

  def chef_node_name
    "#{prefix}#{name}"
  end

  def volume_path_local(v)
    res = v.to_s

    if v =~ /^\./
      s = v.gsub /^\.\//, ''

      #res = "$PWD/servers/#{self.name}/#{s}"
      res = File.expand_path(s, dir_server_root)

    elsif v =~ /^\/\//
      res = self.properties['common']['dir_data']+(v.gsub /^\/\//, '')
    elsif v =~ /^\//
      res = v
    else
      res = self.dir_data+v
    end

    res
  end

  def dir_data
    "#{properties['common']['dir_data']}#{self.name}/"
  end


  ### docker swarm services

  def service_name(name=nil)
    name ||= properties['name']
    s = name

    "#{service_prefix}#{s}"
  end

  ###
  def docker_volumes
    a = properties['docker']['volumes'] || []

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
    a = properties['docker']['volumes_from'] || []

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
    a = properties['docker']['ports'] || []
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
    a = properties['docker']['links'] || []

    a
  end

  def docker_links_string
    docker_links_array.map{|s| "--link #{s}"}.join(' ')
  end

  def docker_links_array
    docker_links.map{|d| docker_link_build(d)}
  end

  def docker_link_build(r)
    # fix
    "#{container_prefix}#{r[0]}:#{r[1]}"
  end

  ###

  def run_env_variables
    a = properties['docker']['run_env'] || []

    a
  end

  def run_env_variables_string
    run_env_variables.map{|r| "-e #{r[0]}=#{r[1]}"}.join(' ')
  end


  ###

  def run_extra_options_string
    s = properties['docker']['run_extra_options'] || ''
    s
  end


  ###
  def is_swarm_mode?
    v = properties["docker"]["swarm_mode"]
    return false if v.nil?
    return v
  end

  ###
  def [](key)
    properties[key]
  end


  ###
  def filename_chef_config
    #File.join(File.dirname(__FILE__), '..', 'config' ,"config-#{name}.json")

    File.join(Config.root_path, 'temp', "#{name}.json")
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

  ###

  def make_path_full(path)
    File.expand_path("#{path}", dir_server_root)
  end

end



class Settings

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

  def self.file_base_settings
    File.join(File.dirname(__FILE__), '..', 'config' ,'common.rb')
  end




end
end
