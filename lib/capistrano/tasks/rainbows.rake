require 'capistrano/nginx_rainbows/helpers'

include Capistrano::NginxRainbows::Helpers

namespace :rainbows do
  desc "Setup Rainbows initializer"
  task :setup_initializer do
    on roles(:app) do
      template "rainbows_init.erb", "/tmp/rainbows_init"
      execute :chmod, "+x", "/tmp/rainbows_init"
      sudo :mv, "/tmp/rainbows_init /etc/init.d/#{fetch(:rainbows_service_name)}"
      sudo "update-rc.d -f #{fetch(:rainbows_service_name)} defaults"
    end
  end

  desc "Setup Rainbows app configuration"
  task :setup_app_config do
    on roles(:app) do
      execute :mkdir, "-p", shared_path.join("config")
      execute :mkdir, "-p", shared_path.join("log")
      execute :mkdir, "-p", shared_path.join("pids")
      template "rainbows.rb.erb", fetch(:rainbows_config)
    end
  end

  %w[start stop restart].each do |command|
    desc "#{command} #{fetch(:rainbows_bin)}"
    task command do
      on roles(:app) do
        sudo "service #{fetch(:rainbows_service_name)} #{command}"
      end
    end
  end
end

namespace :deploy do
  after :publishing, "rainbows:restart"
end
