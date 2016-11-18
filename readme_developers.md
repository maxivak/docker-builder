# For developers


# Build image


Build Docker image with Chef provisioning:

* go to folder where servers are located

* run to build one server

```
# run from folder where servers are located 
docker-builder build -s nginx

# or run from any folder
docker-builder build -s nginx --root-path /path/to/example-nginx

```


* it generates temp json file with node attributes
examples/example-nginx/temp/nginx.json

* runs chef-client to build image

```
SERVER_NAME=nginx chef exec chef-client -z -N nginx -j /mnt/data/projects/mmx/docker-builder/examples/example-nginx/temp/nginx.json lib/docker_builder/chef/chef_build_image.rb 
```

* chef-client takes json file and recipe and create new Docker image and run recipe 'servers/nginx/cookbooks/recipes/build.rb'

* a new Docker image named '<<prefix>>nginx' is created
i.e. example-nginx

docker images 


* run test container

docker run -ti --rm example-nginx /bin/bash

* in the interactive terminal inside the container:
check we have resources from build.rb

* exit container

* container will be automatically destroyed



# Run container

