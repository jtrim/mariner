$:.unshift(File.expand_path('..', __FILE__)) unless $:.include? File.expand_path('..', __FILE__)

require 'abyss'

require 'navigation/version'
require 'navigation/errors'
require 'navigation/url'
require 'navigation/store'

require 'navigation/railtie'

module Abyss

  module Navigation

    class << self
      attr_accessor :configuration
    end

    # Public interface to Navigation Navigation API
    # See NavigationConfig for examples.
    #
    def self.configure(&block)
      self.configuration ||= Store.new
      self.configuration.instance_eval &block
    end

  end

end