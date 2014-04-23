module Capistrano
  module NginxRainbows
    module Generators
      class ConfigGenerator < Rails::Generators::Base
        desc "Create local nginx and rainbows configuration files for customization"
        source_root File.expand_path('../templates', __FILE__)
        argument :templates_path, :type => :string,
          :default => "config/deploy/templates",
          :banner => "path to templates"

        def copy_template
          copy_file "nginx_conf.erb", "#{templates_path}/nginx_conf.erb"
          copy_file "rainbows.rb.erb", "#{templates_path}/rainbows.rb.erb"
          copy_file "rainbows_init.erb", "#{templates_path}/rainbows_init.erb"
          copy_file "logrotate.erb", "#{templates_path}/logrotate.erb"
        end
      end
    end
  end
end
