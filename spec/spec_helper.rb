ENV["RAILS_ENV"] = "test"

$:.unshift File.dirname(__FILE__)
require "rails_app/config/environment"
require 'rspec/rails'
require 'rspec/autorun'

require "capybara/rspec"
require "capybara/rails"

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
end
