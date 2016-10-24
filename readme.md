# Docker builder

Build and run Docker containers with Chef, Dockerfile and other tools.

Config files are in Ruby.

Manage complexity of running Docker containers for your environment in one place.

# Overview

Process of building and running container on the host machine:
* build
    * it will create a Docker image on the host machine
    
* Run container
    * provision host machine - run scripts locally on the host machine
    (recipe install_host.rb)
    * run container (docker run)
    * provision container - run script in the container
    (recipe install.rb)

* Install systemd service to run Docker container (optional)

* Start/Stop container

* Destroy container

* Destroy image
