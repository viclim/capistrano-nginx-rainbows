require 'capistrano/nginx_rainbows/helpers'

include Capistrano::NginxRainbows::Helpers

namespace :nginx do
  desc "Setup nginx configuration"
  task :setup do
    on roles(:web) do
      execute :mkdir, "-p", shared_path.join("log")
      template("nginx_conf.erb", "/tmp/nginx_#{fetch(:nginx_config_name)}")
      if fetch(:nginx_config_path) == "/etc/nginx/sites-available"
        sudo :mv, "/tmp/nginx_#{fetch(:nginx_config_name)} /etc/nginx/sites-available/#{fetch(:nginx_config_name)}"
        sudo :ln, "-fs", "/etc/nginx/sites-available/#{fetch(:nginx_config_name)} /etc/nginx/sites-enabled/#{fetch(:nginx_config_name)}"
      else
        sudo :mv, "/tmp/#{fetch(:nginx_config_name)} #{fetch(:nginx_config_path)}/#{fetch(:nginx_config_name)}"
      end
    end
  end

  desc "Setup nginx ssl certs"
  task :setup_ssl do
    on roles(:web) do
      if fetch(:nginx_use_ssl)
        if fetch(:nginx_upload_local_certificate)
          upload! fetch(:nginx_ssl_certificate_local_path), "/tmp/#{fetch(:nginx_ssl_certificate)}"
          upload! fetch(:nginx_ssl_certificate_key_local_path), "/tmp/#{fetch(:nginx_ssl_certificate_key)}"

          sudo :mv, "/tmp/#{fetch(:nginx_ssl_certificate)} /etc/ssl/certs/#{fetch(:nginx_ssl_certificate)}"
          sudo :mv, "/tmp/#{fetch(:nginx_ssl_certificate_key)} /etc/ssl/private/#{fetch(:nginx_ssl_certificate_key)}"
        end

        sudo :chown, "root:root /etc/ssl/certs/#{fetch(:nginx_ssl_certificate)}"
        sudo :chown, "root:root /etc/ssl/private/#{fetch(:nginx_ssl_certificate_key)}"
      end
    end
  end

  desc "Reload nginx configuration"
  task :reload do
    on roles(:web) do
      sudo "/etc/init.d/nginx reload"
    end
  end
end

namespace :deploy do
  after :publishing, "nginx:reload"
end
