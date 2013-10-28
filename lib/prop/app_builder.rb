require 'travis'
  module Prop
  class AppBuilder < Rails::AppBuilder
    include Prop::Actions

    def resolve_qt4_dependency
      run 'brew install qt4'
      run 'bundle'
    end

    def readme
      template 'README.md.erb', 'README.md'
    end

    def remove_public_index
      remove_file 'public/index.html'
    end

    def remove_rails_logo_image
      remove_file 'app/assets/images/rails.png'
    end

    def raise_on_delivery_errors
      replace_in_file 'config/environments/development.rb',
        'raise_delivery_errors = false', 'raise_delivery_errors = true'
    end

    def raise_on_unpermitted_parameters
      configure_environment 'development',
        'config.action_controller.action_on_unpermitted_parameters = :raise'
    end

    def provide_setup_script
      copy_file 'bin_setup', 'bin/setup'
      run 'chmod a+x bin/setup'
    end

    def configure_generators
      config = <<-RUBY
  config.generators do |generate|
    generate.helper false
    generate.javascript_engine false
    generate.request_specs false
    generate.routing_specs false
    generate.stylesheets false
    generate.test_framework :rspec
    generate.view_specs false
  end
      RUBY

      inject_into_class 'config/application.rb', 'Application', config
    end

    def enable_factory_girl_syntax
      copy_file 'factory_girl_syntax_rspec.rb', 'spec/support/factory_girl.rb'
    end

    def test_factories_first
      copy_file 'factories_spec.rb', 'spec/models/factories_spec.rb'
      append_file 'Rakefile', factories_spec_rake_task
    end

    def configure_smtp
      copy_file 'smtp.rb', 'config/initializers/smtp.rb'

      prepend_file 'config/environments/production.rb',
        "require Rails.root.join('config/initializers/smtp')\n"

      config = <<-RUBY

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = SMTP_SETTINGS
      RUBY

      inject_into_file 'config/environments/production.rb', config,
        :after => 'config.action_mailer.raise_delivery_errors = false'
    end

    def setup_staging_environment
      run 'cp config/environments/production.rb config/environments/staging.rb'

      prepend_file 'config/environments/staging.rb',
        "Mail.register_interceptor RecipientInterceptor.new(ENV['EMAIL_RECIPIENTS'])\n"
    end

    def setup_devise
      run 'rails g devise:install'
      run 'rails g devise User'
      run 'rake db:migrate'
      run 'rails g devise:views'
    end

    def create_partials_directory
      empty_directory 'app/views/application'
    end

    def create_shared_flashes
      copy_file '_flashes.html.erb', 'app/views/application/_flashes.html.erb'
    end

    def create_shared_javascripts
      copy_file '_javascript.html.erb', 'app/views/application/_javascript.html.erb'
    end

    def create_application_layout
      remove_file 'app/views/layouts/application.html.erb'
      copy_file 'prop_layout.html.erb.erb',
        'app/views/layouts/application.html.erb',
        :force => true
    end

    def remove_turbolinks
      replace_in_file 'app/assets/javascripts/application.js',
        /\/\/= require turbolinks\n/,
        ''
    end

    def create_common_javascripts
      directory 'javascripts', 'app/assets/javascripts'
    end

    def use_postgres_config_template
      template 'postgresql_database.yml.erb', 'config/database.yml',
        :force => true
    end

    def create_database
      begin
        bundle_command 'exec rake db:create'
      rescue
        run 'pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
        bundle_command 'exec rake db:create'
      end
    end

    def replace_gemfile
      remove_file 'Gemfile'
      copy_file 'Gemfile_clean', 'Gemfile'
    end

    def set_ruby_to_version_being_used
      inject_into_file 'Gemfile', "\n\nruby '#{RUBY_VERSION}'",
        after: /source 'https:\/\/rubygems.org'/
    end

    def enable_database_cleaner
      copy_file 'database_cleaner_rspec.rb', 'spec/support/database_cleaner.rb'
    end

    def configure_rspec
      remove_file 'spec/spec_helper.rb'
      copy_file 'spec_helper.rb', 'spec/spec_helper.rb'
    end

    def use_rspec_binstub
      run 'bundle binstub rspec-core'
      run 'rm bin/autospec'
    end

    def generate_login_specs
      empty_directory 'spec/features'
      copy_file 'user_sign_up_spec.rb', 'spec/features/user_sign_up_spec.rb'
      copy_file 'user_sign_in_spec.rb', 'spec/features/user_sign_in_spec.rb'
    end

    def clean_up_factories
      remove_file 'spec/factories/users.rb'
      remove_file 'spec/models/user_spec.rb'
      remove_file 'app/views/devise/registrations/new.html.erb'
      copy_file 'factories.rb', 'spec/factories/factories.rb'
    end

    def create_controller_for_sign_in
      copy_file 'new_registration.html.erb', 'app/views/devise/registrations/new.html.erb'
      replace_in_file 'config/routes.rb',
        /Application\.routes\.draw do/,
        "Application.routes.draw do\nroot to: 'application#index'\n"
      remove_file 'app/controllers/application_controller.rb'
      copy_file 'application_controller.rb', 'app/controllers/application_controller.rb'
      copy_file 'root_index.html.erb', 'app/views/application/index.html.erb'
    end

    def enable_logout
      empty_directory 'app/views/shared'
      copy_file 'nav_bar.html.erb', 'app/views/shared/_nav_bar.html.erb'
      replace_in_file 'config/initializers/devise.rb', /config\.sign_out_via = \:delete/, "config.sign_out_via = :get\n"
    end

    def migrate_test_db
      run 'rake db:test:prepare'
    end

    def configure_background_jobs_for_rspec
      copy_file 'background_jobs_rspec.rb', 'spec/support/background_jobs.rb'
      run 'rails g delayed_job:active_record'
    end

    def configure_time_zone
      config = <<-RUBY
    config.active_record.default_timezone = :utc

      RUBY
      inject_into_class 'config/application.rb', 'Application', config
    end

    def configure_time_formats
      remove_file 'config/locales/en.yml'
      copy_file 'config_locales_en.yml', 'config/locales/en.yml'
    end

    def configure_rack_timeout
      copy_file 'rack_timeout.rb', 'config/initializers/rack_timeout.rb'
    end

    def configure_action_mailer
      action_mailer_host 'development', "#{app_name}.local"
      action_mailer_host 'test', 'www.example.com'
      action_mailer_host 'staging', "staging.#{app_name}.com"
      action_mailer_host 'production', "#{app_name}.com"
    end

    def generate_rspec
      generate 'rspec:install'
    end

    def generate_clearance
      generate 'clearance:install'
    end

    def configure_unicorn
      copy_file 'unicorn.rb', 'config/unicorn.rb'
    end

    def setup_foreman
      copy_file 'sample.env', '.sample.env'
      copy_file 'Procfile', 'Procfile'
    end

    def setup_stylesheets
      remove_file 'app/assets/stylesheets/application.css'
      copy_file 'application.css.scss',
        'app/assets/stylesheets/application.css.scss'
    end

    def setup_google_places
      copy_file 'places.coffee', 'app/assets/javascripts/places.coffee'
    end

    def setup_guardfile
      copy_file 'Guardfile', 'Guardfile'
    end

    def init_zeus
      run 'zeus init'
    end

    def gitignore_files
      remove_file '.gitignore'
      copy_file 'prop_gitignore', '.gitignore'
      [
        'app/views/pages',
        'spec/lib',
        'spec/controllers',
        'spec/helpers',
        'spec/support/matchers',
        'spec/support/mixins',
        'spec/support/shared_examples'
      ].each do |dir|
        run "mkdir #{dir}"
        run "touch #{dir}/.keep"
      end
    end

    def init_git
      run 'git init'
    end

    def create_heroku_apps
      path_addition = override_path_for_tests
      run "#{path_addition} heroku create #{app_name}-production --remote=production"
      run "#{path_addition} heroku create #{app_name}-staging --remote=staging"
      run "#{path_addition} heroku config:add RACK_ENV=staging RAILS_ENV=staging --remote=staging"
    end

    def set_heroku_remotes
      begin
        concat_file(
          'templates/bin_setup',
          "# Set up staging and production git remotes\r
          git remote add staging git@heroku.com: #{app_name}-staging.git\r
          git remote add production git@heroku.com: #{app_name}-production.git"
        )
      rescue
      end
    end

    def create_github_repo(repo_name)
      path_addition = override_path_for_tests
      run "#{path_addition} hub create #{repo_name}"
    end

    def setup_travis_ci
      path_addition = override_path_for_tests
      run "#{path_addition} travis login --org --auto"
      run "#{path_addition} travis sync"
      run "#{path_addition} travis enable"
      copy_file '.travis.yml', '.travis.yml'
    end

    def self.github_username
      `travis login --org --auto`
      tk = `travis token`
      token = tk.split(' ').pop
      client = ::Travis::Client.new(access_token: "#{token}")
      client.user.login
    end

    def initial_commit_and_push
      path_addition = override_path_for_tests
      run "#{path_addition} git add ."
      run "#{path_addition} git commit -m 'Initial Commit'"
      run "#{path_addition} git push -u origin master"
    end

    def copy_miscellaneous_files
      copy_file 'errors.rb', 'config/initializers/errors.rb'
    end

    def customize_error_pages
      meta_tags =<<-EOS
  <meta charset='utf-8' />
  <meta name='ROBOTS' content='NOODP' />
      EOS

      %w(500 404 422).each do |page|
        inject_into_file "public/#{page}.html", meta_tags, :after => "<head>\n"
        replace_in_file "public/#{page}.html", /<!--.+-->\n/, ''
      end
    end

    def remove_routes_comment_lines
      replace_in_file 'config/routes.rb',
        /Application\.routes\.draw do.*end/m,
        "Application.routes.draw do\nend"
    end

    def setup_foundation
      remove_file 'app/views/layouts/application.html.erb'
      run 'rails g foundation:install'
    end

    def setup_modernizr
      copy_file 'modernizr.js', 'app/assets/javascripts/modernizr.js'
    end

    def setup_backbone
      copy_file 'backbone.js', 'app/assets/javascripts/backbone.js'
      copy_file 'underscore.js', 'app/assets/javascripts/underscore.js'
    end

    def setup_application_js
      remove_file 'app/assets/javascripts/application.js'
      copy_file 'application.js', 'app/assets/javascripts/application.js'
    end

    def setup_backbone_rails
      run 'rails g backbone:install'
    end

    def disable_xml_params
      copy_file 'disable_xml_params.rb', 'config/initializers/disable_xml_params.rb'
    end

    def setup_default_rake_task
      append_file 'Rakefile' do
        "task(:default).clear\ntask :default => [:spec]\n"
      end
    end

    def start_zeus
      run "launch () {
        PWD = pwd
        /usr/bin/osascript <<-EOF
        tell application \"iTerm\"
            make new terminal
            tell the current terminal
                activate current session
                launch session \"Default Session\"
                tell the last session
                    write text \"cd $PWD\"
                    write text \"zeus start\"
                end tell
            end tell
        end tell
        EOF
        }
        launch"
    end

    private

    def override_path_for_tests
      if ENV['TESTING']
        support_bin = File.expand_path(File.join('..', '..', '..', 'features', 'support', 'bin'))
        "PATH=#{support_bin}:$PATH"
      end
    end

    def factories_spec_rake_task
      IO.read find_in_source_paths('factories_spec_rake_task.rb')
    end
  end
end
