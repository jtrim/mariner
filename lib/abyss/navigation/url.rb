module Abyss

  module Navigation

    # Public: Represents a Url configuration.
    #
    # Examples:
    #
    #     Abyss::Navigation.configure do
    #       a_group do
    #         root_path "A Link" # <= This ends up being a Url instance.
    #       end
    #     end
    #
    class Url

      attr_accessor :name, :title, :options

      # Public: Create a new Url
      #
      # name    - The method name that corresponds to a Rails route helper
      # title   - The text that should be rendered to represent a url.
      # options - Any link options that should be present. Used by the
      #           renderer (default: {})
      #
      def initialize(name, title, options={})
        @name, @title, @options = name, title, options
      end

      # Public: Renders itself through a rendering strategy.
      #
      # rendering_strategy - The rendering strategy to use. Must respond to
      #                      #render (default: UnorderedListRenderer.new)
      #
      def render(rendering_strategy=UnorderedListRenderer.new)
        rendering_strategy.factory(:item, self).render
      end

      # Public: Calls the Rails route helper method to get its href.
      #
      def href
        begin
          # The link's name should be the method name
          # for a rails route helper. We're including the route
          # helpers in an initializer, so this will only fail if
          # the route is undefined.
          #
          send(name)
        rescue NoMethodError => e
          raise ::Abyss::Errors::InvalidUrlHelperMethod.new(name)
        end
      end

    end

  end

end
