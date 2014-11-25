# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'shoulda/matchers'
require 'billy/rspec'
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!
Capybara.javascript_driver = :poltergeist_billy
Warden.test_mode!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.include FactoryGirl::Syntax::Methods
  config.include Devise::TestHelpers, type: :controller
  config.include ResponseMacros, type: :controller
  config.include Warden::Test::Helpers, type: :feature
  config.extend FeatureDevise, type: :feature
  config.include Rails.application.routes.url_helpers, type: :feature
  config.extend DeviseMacros,     type: :controller
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)

    Warden.test_reset!

    Billy.configure do |c|
      c.whitelist = ['test.host', 'localhost', '127.0.0.1', "http://www.example.com/"]
    end
  end

  config.around(:each) do |example|
    ActionMailer::Base.deliveries.clear
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!
end
