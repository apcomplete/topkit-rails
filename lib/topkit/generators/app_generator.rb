require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Topkit
  class AppGenerator < Rails::Generators::AppGenerator
    class_option :gitlab, type: :string, aliases: '-G', default: false

    def finish_template
      invoke :topkit_customization
      super
    end

    def topkit_customization
      invoke :configure_generators
      invoke :customize_gemfile
      invoke :setup_database
      invoke :remove_useless_files
      invoke :remove_routes_comment_lines
      invoke :setup_staging_environment
      invoke :create_views_and_layouts
      invoke :copy_miscellaneous_files
      invoke :configure_rspec
      invoke :configure_backbone
      invoke :setup_git
    end

    def configure_generators
      say "Configuring rspec generators"
      build :configure_rspec_generators
    end

    def customize_gemfile
      say "Setting up gems"
      build :replace_gemfile
      bundle_command "install"
      bundle_command "package"
    end

    def setup_database
      say "Setting up database"
      build :template_database_file
      build :create_database
    end

    def remove_useless_files
      build :remove_public_index
      build :remove_rails_logo_image
    end

    def remove_routes_comment_lines
      build :remove_routes_comment_lines
    end

    def setup_staging_environment
      say "Setting up staging environment"
      build :setup_staging_environment
      #build :setup_staging_recipes
    end

    def create_views_and_layouts
      say "Creating partials and default layout"
      build :create_partials_directory
      build :create_status_partials
      build :create_application_layout
    end

    def copy_miscellaneous_files
    end

    def configure_rspec
      build :configure_rspec
    end

    def configure_backbone
      build :generate_backbone
    end

    def setup_git
      say "Initializing git repo"
      build :add_to_git_ignore
      build :init_git
    end

    def outro
      say 'You are good to go!'
    end

    def run_bundle
    end

    protected

    def get_builder_class
      Topkit::AppBuilder
    end

  end
end
