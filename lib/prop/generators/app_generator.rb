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
      default: nil,
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
    end

    def remove_garbage_files
      build :remove_public_index
      build :remove_rails_logo_image
    end
  end
end
