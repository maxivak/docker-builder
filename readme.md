# Docker builder

Tool to build and install Docker containers with Chef, Dockerfile and other provisioning tools.

Features:
* Config files are in Ruby.
* Manage complexity of running Docker containers for your environment in one place.
* Manage multiple containers


Other tools:
* docker-composer - with configs in yml



# Overview


Build Docker image:
* from Dockerfile
* Chef provisioning (machine_image) 

Provision during installation container on the host machine by:
* running shell script inside container
* running Chef script inside container with Chef provisioning



# Installation

* Install gem:
```
gem install docker-builder
```



# Quickstart

We will build and run a simple Docker container with Nginx server.

* install gem

```
gem install docker-builder
```


* generate directory structure using generator

```
docker-builder generate --name=nginx --type=chef
``` 

it will create a folder `nginx` with necessary directory structure inside.


* in the folder edit config file `config.rb` with common settings

```
common({
    'prefix' => "example-",
    'image_prefix' => 'example-',
    'dir_data' => '/disk3/data/my-examples/',

})

servers({
    'nginx'=>{
        # some server options here
    },


})


base({

})


```

* edit custom settings for the server in file `servers/nginx/config.rb`
 
```

add 'build', {
    "image_name" => "nginx",
    'build_type' => 'chef',
    "base_image" => {        "name" => "nginx",        "repository" => "nginx",        "tag" => "1.10"    },

}

add 'install', {
    "host" => {      'script_type' => 'chef_recipe',       'script' => 'install_host',    },
    "node" => {       'script_type' => 'chef_recipe',       'script' => 'install',    }
}

add 'docker', {
    "command"=> "nginx -g 'daemon off;'",
    'ports' => [
        [8080,80],
    ],
    'volumes' => [
        ['html', '/usr/share/nginx/html'],
        ['log/nginx', '/var/log/nginx/'],
    ],
    'links' => [    ]
}

add 'attributes', {
  'nginx' =>{
      "sitename" =>"mysite.local"
  },


}


```

* build Docker image

```
# from the folder with project

docker-builder build
```

* run container

```
docker-builder up
```

* check container is running
```
docker ps

# see container named example-nginx
```

* access container 

```
docker exec -ti example-nginx /bin/bash
```

* access container from browser

```
http://localhost:8080
```






# Basic usage

# Provision wich shell script

* put scripts in `/path/to/project/ <<server_name>> / scripts / install.sh`


# Provisioning with Chef

Process of building and running container on the host machine:
* Build Docker image
    * it will create a Docker image on the host machine
    
* Run Docker container
    * provision host machine - run scripts locally on the host machine
    (recipe install_host.rb)
    * run container (docker run)
    * provision container - run script in the container
    (recipe install.rb)

* Install systemd service to run Docker container (optional)

* Start/Stop container

* Destroy container

* Destroy image


## Install server with Chef provisioning
 
* generate directory structure using generator
```
docker-builder generate --name=nginx --type=chef
``` 

it will create a folder `nginx`

* in the folder edit config file `config.rb` with common settings

```

```

* edit custom settings for the server in file `servers/nginx/config.rb`
 
```
```

* build Docker image

```
# from the folder with project

docker-builder build
```

* run container

```
docker-builder up
```

* check container is running
```
docker ps
```

* access container from browser

```
http://localhost:8080
```





# Usage


* Build docker image

```
cd /path/to/servers

docker-builder build -s server_name
```

* run docker container

```
cd /path/to/servers

docker-builder run -s server_name
```

it will run container.

access container:

```
docker exec -ti container_name /bin/bash
```



## Development

After checking out the repo, run `bin/setup` to install dependencies. 
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).




# Configuration

* edit config.rb in your root folder

You can put all settings in this config.rb file and/or use config.rb file in each server's folder.

Config files:
```
/path/to/project/config.rb
/path/to/project/servers/server1/config.rb
/path/to/project/servers/server2/config.rb
```


## config.rb


* CHEF_COOKBOOKS - list of paths to chef cookbooks


# Build Docker image

Build types:
* 'none' - no build required
* 'Dockerfile' - using Dockerfile and docker build command
* 'chef' - using Chef provisioning


# Chef provisioning

* add additional paths for cookbooks

in folder with servers:

```
# /path/to/my/servers/.chef/knife.rb

cookbook_path cookbook_path+[
    '/path/to/my/cookbooks',
    '/path/to/my/other/cookbooks',
]

```


# Build Docker container with Chef

Example of building Docker container with Chef.

Assume that our server name is 'nginx'.


* edit config file 'myserver/config.rb'

```
####
```

* Chef recipes
* cookbooks/nginx/recipes/build.rb 
place chef resources to be included in the Docker image

* cookbooks/nginx/recipes/install.rb

* cookbooks/nginx/recipes/install_host.rb

* build

```
# run from the folder

docker-builder build['nginx']
```

* shared data:
/disk3/data/server-api/nginx-front

data for nginx server:
* /etc/nginx/conf.d
* /var/www/html
* /var/log/nginx


* Main site - /var/www/html ==> /disk3/data/server-api/nginx-front/var/www/html

 

* Config


## Run container



## Manage multiple servers






# Build container

## Build from Dockerfile

* config for server
```
'build' => {
      'build_type' => 'Dockerfile',
      "image_name" => "myname",

      "base_image" => {} # not used
  },
```

# Run container


## Run from existing image

* config for server
```
'build' => {
      'build_type' => 'none',
      "image_name" => "myname",

      "base_image" => {
          "name" => "mysql", 
          "repository" => "mysql", 
          "tag" => "3.4.9"
      },
  },
      
```

it will NOT build a new Docker image.



## Run Docker container with Chef

* run recipe install_host which runs on the host machine (not in container)
* run recipe install which runs from within the running container 



# Other tools

* packer - https://github.com/mitchellh/packer

Packer is a tool for creating identical machine images for multiple platforms from a single source configuration.



# Docker options for running container

* additional options for docker run command 
* hostname

```
{
..
servers({
    'zookeeper'=>{
    ...
        'docker'=> {
            ...
            'run_extra_options'=>'--hostname zookeeper'
        }
}
```

