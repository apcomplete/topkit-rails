module Topkit
  class AppBuilder < Rails::AppBuilder

    def remove_public_index
      remove_file 'public/index.html'
    end

    def remove_rails_logo_image
      remove_file 'app/assets/images/rails.png'
    end

    def setup_staging_environment
      run "cp config/environments/production.rb config/environments/staging.rb"
    end

    def create_partials_directory
      empty_directory 'app/views/application'
    end

    def create_status_partials
      copy_file '_status.html.erb', 'app/views/application/_status.html.erb'
    end

    def create_application_layout
      remove_file "app/views/layouts/application.html.erb"
      copy_file "application_layout.html.erb", "app/views/layouts/application.html.erb", force: true
    end

  end
end
