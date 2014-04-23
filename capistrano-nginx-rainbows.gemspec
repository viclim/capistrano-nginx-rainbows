# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/nginx_rainbows/version'

Gem::Specification.new do |gem|
  gem.name          = "capistrano-nginx-rainbows"
  gem.version       = Capistrano::NginxRainbows::VERSION
  gem.authors       = ["Ivan Tkalin", "Kalys Osmonov"]
  gem.email         = ["kalys@osmonov.com"]
  gem.description   = %q{Capistrano tasks for configuration and management nginx+rainbows combo for zero downtime deployments of Rails applications. Configs can be copied to the application using generators and easily customized.}
  gem.summary       = %q{Create and manage nginx+rainbows configs from capistrano}
  gem.homepage      = "https://github.com/viclim/capistrano-nginx-rainbows"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'capistrano', '~> 3.0'

  gem.add_development_dependency "rake"
end
