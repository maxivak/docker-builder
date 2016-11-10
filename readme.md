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



## Installation

Add this line to your application's Gemfile:

```ruby
gem 'docker-builder'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install docker-builder

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/docker-builder. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).



# Settings

* CHEF_COOKBOOKS - list of paths to chef cookbooks


# Examples


# For developers





# Build container

# Run container


## Run Docker container with Chef

* run recipe install_host which runs on the host machine (not in container)
* run recipe install which runs from within the running container 
