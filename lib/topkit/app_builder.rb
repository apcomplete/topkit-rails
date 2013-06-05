module Topkit
  class AppBuilder < Rails::AppBuilder
    include Topkit::Actions

    def configure_rspec_generators
      config = <<-RUBY
    config.generators do |g|
      g.fixture true
      g.fixture_replacement "factory_girl"
      g.assets false
      g.test_framework :rspec
      g.view_specs false
      g.controller_specs false
      g.helper_specs false
      g.routing_specs false
      g.request_specs false
      g.stylesheets false
    end

      RUBY

      inject_into_class 'config/application.rb', 'Application', config
    end

    def replace_gemfile
      remove_file 'Gemfile'
      copy_file 'Gemfile_clean', 'Gemfile'
    end

    def template_database_file
      template 'database.mysql.yml.erb', 'config/database.yml', force: true
    end

    def create_database
      bundle_command "exec rake db:create"
    end

    def remove_public_index
      remove_file 'public/index.html'
    end

    def remove_rails_logo_image
      remove_file 'app/assets/images/rails.png'
    end

    def remove_routes_comment_lines
      replace_in_file 'config/routes.rb',
        /Application\.routes\.draw do.*end/m,
        "Application.routes.draw do\nend"
    end

    def setup_staging_environment
      run "cp config/environments/production.rb config/environments/staging.rb"
      replace_in_file "config/environments/staging.rb", "config.serve_static_assets = false", "config.serve_static_assets = true"
      replace_in_file "config/environments/staging.rb", "config.assets.compile = false", "config.assets.compile = true"
      replace_in_file "config/environments/staging.rb", "# config.log_level = :debug", "config.log_level = :debug"
    end

    def create_partials_directory
      empty_directory 'app/views/application'
    end

    def create_status_partials
      copy_file '_status.html.erb', 'app/views/application/_status.html.erb'
      copy_file '_header.html.erb', 'app/views/application/_header.html.erb'
      copy_file '_footer.html.erb', 'app/views/application/_footer.html.erb'
    end

    def create_application_layout
      remove_file "app/views/layouts/application.html.erb"
      copy_file "application_layout.html.erb", "app/views/layouts/application.html.erb", force: true
    end

    def generate_rspec
      generate 'rspec:install'
    end

    def generate_backbone
      generate "backbone:install"
    end

    def generate_backtrace
      download_file "https://gist.github.com/apcomplete/4113645/download", "vendor/assets/javascripts/backtrace.js"
    end

    def add_relative_url_root
      relative_root = <<-eos
  #Deploy staging to subdirectory
  config.action_controller.relative_url_root = '/#{options[:client]}/#{options[:project]}'
      eos
      inject_into_file "config/environments/staging.rb", "\n#{relative_root}", after: "config.serve_static_assets = true\n"

      replace_in_file "config.ru",
        "run #{app_const}",
        %(map ActionController::Base.config.relative_url_root || "/" do\n  run #{app_const}\nend)
    end

    def enable_database_cleaner
      replace_in_file 'spec/spec_helper.rb',
        'config.use_transactional_fixtures = true',
        'config.use_transactional_fixtures = false'

      copy_file 'database_cleaner_rspec.rb', 'spec/support/database_cleaner.rb'
    end

    def setup_stylesheets
      remove_file 'app/assets/stylesheets/application.css'
      create_file 'app/assets/stylesheets/application.css.scss'
    end

    def generate_devise
      generate "devise:install"
      generate "devise User"
      bundle_command "exec rake db:migrate"
      generate "devise:views"
    end

    def add_admin_to_gemfile
      admin_gems = <<-eos
      gem 'devise'
      gem 'rails_admin'
      gem 'rich'
      eos
      inject_into_file 'Gemfile', "\n#{new_gems}", after: /gem 'kaminari'/
      bundle_command "install"
    end

    def generate_admin
      generate "rails_admin:install"
    end

    def generate_rich_editor
      generate "rich:install"
      bundle_command "exec rake db:migrate"
    end

    def generate_cucumber
      generate 'cucumber:install', '--rspec', '--capybara'
    end

    def init_git
      run 'git init'
    end

    def add_to_git_ignore
      concat_file 'topkit_gitignore', '.gitignore'
    end

  end
end
