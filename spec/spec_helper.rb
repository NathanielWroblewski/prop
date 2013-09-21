ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'paperclip/matchers'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Default
  config.include Paperclip::Shoulda::Matchers
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false

  config.order = "random"
  config.color = true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
