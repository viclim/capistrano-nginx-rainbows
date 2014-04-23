# Capistrano-Nginx-Rainbows

Capistrano tasks for configuration and management nginx+rainbows combo for zero downtime deployments of Rails applications.

Provides capistrano tasks to:

* easily add application to nginx and reload it's configuration
* create rainbows init script for application, so it will be automatically started when OS restarts
* start/stop rainbows (also can be done using `sudo service rainbows_<your_app> start/stop`)
* reload rainbows using `USR2` signal to load new application version with zero downtime
* creates logrotate record to rotate application logs

Provides several capistrano variables for easy customization.
Also, for full customization, all configs can be copied to the application using generators.

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano-nginx-rainbows', group: :development

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-nginx-rainbows

## Usage

Add this line to your `Capfile`

    require 'capistrano/nginx_rainbows'

You can check that new tasks are available (`cap -T`):

for nginx:

    # add and enable application to nginx
    cap nginx:setup

    # upload ssl certificates
    cap nginx:setup_ssl

    # reload nginx configuration
    cap nginx:reload

and for rainbows:

    # create rainbows init script
    cap rainbows:setup_initializer

    # create rainbows configuration file
    cap rainbows:setup_app_config

    # start rainbows
    cap rainbows:start

    # stop rainbows
    cap rainbows:stop

    # reload rainbows with no downtime
    # old workers will process new request until new master is fully loaded
    # then old workers will be automatically killed and new workers will start processing requests
    cap rainbows:restart

and shared:

    # create logrotate record to rotate application logs
    cap logrotate:setup

### Hooks
`nginx:reload`, `rainbows:restart` are hooked to `deploy:publishing`

## Customization

### Using variables

You can customize nginx and rainbows configs using capistrano variables:


```
# path to customized templates (see below for details)
# default value: "config/deploy/templates"
set :templates_path, "config/deploy/templates"

# server name for nginx, default value: "localhost <application>.local"
# set this to your site name as it is visible from outside
# this will allow 1 nginx to serve several sites with different `server_name`
set :nginx_server_name, "example.com"

# path, where nginx pid file will be stored (used in logrotate recipe)
# default value: `"/run/nginx.pid"`
set :nginx_pid, "/run/nginx.pid"

# if set, nginx will be configured to 443 port and port 80 will be auto rewritten to 443
# also, on `nginx:setup`, paths to ssl certificate and key will be configured
# and certificate file and key will be copied to `/etc/ssl/certs` and `/etc/ssl/private/` directories
# default value: false
set :nginx_use_ssl, false

# if set, it will ask to upload certificates from a local path. Otherwise, it will expect
# the certificate and key defined in the next 2 variables to be already in the server.
set :nginx_upload_local_certificate, { true }

# remote file name of the certificate, only makes sense if `nginx_use_ssl` is set
# default value: `nginx_server_name + ".crt"`
set :nginx_ssl_certificate, "#{nginx_server_name}.crt"

# remote file name of the certificate, only makes sense if `nginx_use_ssl` is set
# default value: `nginx_server_name + ".key"`
set :nginx_ssl_certificate_key, "#{nginx_server_name}.key"

# nginx config file location
# centos users can set `/etc/nginx/conf.d`
# default value: `/etc/nginx/sites-available`
set :nginx_config_path, "/etc/nginx/sites-available"

# path, where rainbows pid file will be stored
# default value: `"#{current_path}/tmp/pids/rainbows.pid"`
set :rainbows_pid, "#{current_path}/tmp/pids/rainbows.pid"

# path, where rainbows config file will be stored
# default value: `"#{shared_path}/config/rainbows.rb"`
set :rainbows_config, "#{shared_path}/config/rainbows.rb"

# path, where rainbows log file will be stored
# default value: `"#{shared_path}/config/rainbows.rb"`
set :rainbows_log, "#{shared_path}/config/rainbows.rb"

# user name to run rainbows
# default value: `user` (user varibale defined in your `deploy.rb`)
set :rainbows_user, "user"

# number of rainbows workers
# default value: 2
set :rainbows_workers, 2

# local path to file with certificate, only makes sense if `nginx_use_ssl` is set
# this file will be copied to remote server
# default value: none (will be prompted if not set)
set :nginx_ssl_certificate_local_path, "/home/ivalkeen/ssl/myssl.cert"

# local path to file with certificate key, only makes sense if `nginx_use_ssl` is set
# this file will be copied to remote server
# default value: none (will be prompted if not set)
set :nginx_ssl_certificate_key_local_path, "/home/ivalkeen/ssl/myssl.key"
```

For example, of you site name is `example.com` and you want to use 4 rainbows workers,
your `deploy.rb` will look like this:

```ruby
set :nginx_server_name, "example.com"
set :rainbows_workers, 4
```

### Template Customization

If you want to change default templates, you can generate them using `rails generator`

    rails g capistrano:nginx_rainbows:config

This will copy default templates to `config/deploy/templates` directory,
so you can customize them as you like, and capistrano tasks will use this templates instead of default.

You can also provide path, where to generate templates:

    rails g capistrano:nginx_rainbows:config config/templates

# TODO:

* add tests

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
