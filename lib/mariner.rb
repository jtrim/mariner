$:.unshift(File.expand_path('..', __FILE__)) unless $:.include? File.expand_path('..', __FILE__)

require 'abyss'

require 'mariner/version'
require 'mariner/errors'
require 'mariner/renderer/base'
require 'mariner/unordered_list_renderer'
require 'mariner/url'
require 'mariner/store'

require 'mariner/helper'
require 'mariner/railtie'

module Mariner

  class << self
    attr_accessor :configuration, :rendering_strategies
  end

  @rendering_strategies = {
    :default => UnorderedListRenderer.new
  }

  # Public: The public interface to navigation API
  #
  # Examples:
  #
  #     Mariner.configure do
  #       an_arbitrary_group do
  #         root_path "Go Home"                                     #=> where `root_path` is a Rails route helper
  #         users_path "Manage Users", { "data-name" => "go-home" } #=> note the optional attributes hash. This
  #                                                                 #   is used by rendering strategies
  #       end
  #     end
  #
  def self.configure(&block)
    self.configuration ||= Store.new.tap { |s| s.virtual = true }
    self.configuration.instance_eval &block
  end

  def self.include_helper
    ActiveSupport.on_load(:action_controller) do
      include Mariner::Helper
      helper_method :render_navigation #:notest:
    end
  end

end
