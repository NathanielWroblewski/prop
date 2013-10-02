require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Prop
  class AppGenerator < Rails::Generators::AppGenerator
    class_option :database,
      type: :string,
      aliases: '-d',
      default: 'postgresql',
      desc: "Preconfigure for selected database (options: #{DATABASES.join('/')})"

    class_option :heroku,
      type: :boolean,
      aliases: '-H',
      default: true,
      desc: 'Create staging and production Heroku apps'

    class_option :github,
      type: 'string',
      aliases: '-G',
      default: true,
      desc: 'Create github repo and add remote origin'

    class_option :skip_test_unit,
      type: :boolean,
      aliases: '-T',
      default: true,
      desc: 'Skip Test::Unit files'

    def finish_template
      invoke :prop_customizations
      super
    end

    def prop_customizations
      invoke :remove_garbage_files
      invoke :customize_gemfile
      invoke :setup_database
      invoke :setup_development_environment
      invoke :setup_test_environment
      invoke :setup_production_environment
      invoke :setup_staging_environment
      invoke :create_prop_views
      invoke :setup_coffeescript
      invoke :configure_app
      invoke :setup_stylesheets
      invoke :copy_miscellaneous_files
      invoke :customize_error_pages
      invoke :remove_routes_comment_lines
      invoke :setup_backbone
      invoke :setup_backbone_rails
      invoke :setup_foundation
      invoke :setup_application_js
      invoke :setup_google_places
      invoke :create_guard_file
      invoke :initialize_zeus
      invoke :setup_git
      invoke :create_heroku_apps
      invoke :create_github_repo
      invoke :start_zeus
      invoke :outro
    end

    def remove_garbage_files
      build :remove_public_index
      build :remove_rails_logo_image
    end

    def customize_gemfile
      build :replace_gemfile
      build :set_ruby_to_version_being_used
      bundle_command 'install'
    end

    def setup_database
      say 'Setting up database'
      build :use_postgres_config_template
      build :create_database
    end

    def setup_development_environment
      say 'Setting up the development environment'
      build :raise_on_delivery_errors
      build :raise_on_unpermitted_parameters
      build :provide_setup_script
      build :configure_generators
    end

    def setup_test_environment
      say 'Setting up the test environment'
      build :enable_factory_girl_syntax
      build :test_factories_first
      build :generate_rspec
      build :configure_rspec
      build :use_rspec_binstub
      build :conifigure_background_jobs_for_rspec
      build :enable_database_cleaner
      build :configure_capybara_webkit
    end

    def setup_production_environment
      say 'Setting up the production environment'
      build :configure_smtp
    end

    def setup_staging_environment
      say 'Setting up the staging environment'
      build :setup_staging_environment
    end

    def create_prop_views
      say 'Creating prop views'
      build :create_partials_directory
      build :create_shared_flashes
      build :create_shared_javascripts
      build :create_application_layout
    end

    def setup_coffeescript
      say 'Setting up CoffeeScript defaults'
      build :remove_turbolinks
      build :create_common_javascripts
    end

    def configure_app
      say 'Configuring app'
      build :configure_action_mailer
      build :blacklist_active_record_attributes
      build :configure_strong_parameters
      build :configure_time_zone
      build :configure_time_formats
      build :configure_rack_timeout
      build :disable_xml_params
      build :setup_default_rake_task
      build :configure_unicorn
      build :setup_foreman
    end

    def setup_stylesheets
      say 'Setting up stylesheets'
      build :setup_stylesheets
    end

    def setup_google_places
      say 'Integrating Google Places library'
      build :setup_google_places
    end

    def create_guard_file
      say 'Creating Guardfile'
      build :setup_guardfile
    end

    def initialize_zeus
      build :init_zeus
    end

    def setup_git
      say 'Initializing git'
      invoke :setup_gitignore
      invoke :init_git
    end

    def create_heroku_apps
      if options[:heroku]
        say 'Creating Heroku apps'
        build :create_heroku_apps
        build :set_heroku_remotes
      end
    end

    def create_github_repo
      say 'Creating Github repo'
      build :create_github_repo, "#{app_name}"
    end

    def setup_gitignore
      build :gitignore_files
    end

    def init_git
      build :init_git
    end

    def copy_libraries
      say 'Copying libraries'
      build :copy_libraries
    end

    def copy_miscellaneous_files
      say 'Copying miscellaneous support files'
      build :copy_miscellaneous_files
    end

    def customize_error_pages
      say 'Customizing the 500/404/422 pages'
      build :customize_error_pages
    end

    def remove_routes_comment_lines
      build :remove_routes_comment_lines
    end

    def setup_foundation
      build :setup_foundation
    end

    def setup_backbone
      build :setup_backbone
    end

    def setup_backbone_rails
      build :setup_backbone_rails
    end

    def setup_application_js
      build :setup_application_js
    end

    def start_zeus
      build :start_zeus
    end

    def outro
      say 'Propped up.'
    end

    protected

    def get_builder_class
      Prop::AppBuilder
    end

    def using_active_record?
      !options[:skip_active_record]
    end
  end
end
