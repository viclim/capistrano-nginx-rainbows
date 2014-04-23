set :templates_path, "config/deploy/templates"
set :nginx_server_name, -> { "localhost #{fetch(:application)}.local" }
set :nginx_config_name, -> { "#{fetch(:application)}_#{fetch(:stage)}" }
set :nginx_use_ssl, false
set :nginx_pid, "/run/nginx.pid"
set :nginx_ssl_certificate, -> { "#{fetch(:nginx_server_name)}.crt" }
set :nginx_ssl_certificate_key, -> { "#{fetch(:nginx_server_name)}.key" }
set :nginx_upload_local_certificate, true
set :nginx_ssl_certificate_local_path, -> { ask(:nginx_ssl_certificate_local_path, "Local path to ssl certificate: ") }
set :nginx_ssl_certificate_key_local_path, -> { ask(:nginx_ssl_certificate_key_local_path, "Local path to ssl certificate key: ") }
set :nginx_config_path, "/etc/nginx/sites-available"

set :rainbows_bin, -> { 'rainbows' }
set :rainbows_service_name, -> { "rainbows_#{fetch(:application)}_#{fetch(:stage)}" }
set :rainbows_pid, -> { shared_path.join("pids/rainbows.pid") }
set :rainbows_config, -> { shared_path.join("config/rainbows.rb") }
set :rainbows_log, -> { shared_path.join("log/rainbows.log") }
set :rainbows_user, -> { fetch(:user) }
set :rainbows_workers, 2
set :rainbows_env, -> { fetch(:rails_env) == "staging" ? "staging" : "production" }
set :sudo, "sudo"
