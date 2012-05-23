ENV["RAILS_ENV"] = "test"

$:.unshift File.dirname(__FILE__)
require "rails_app/config/environment"

require 'rspec/rails'
require 'rspec/autorun'
require "capybara/rails"
