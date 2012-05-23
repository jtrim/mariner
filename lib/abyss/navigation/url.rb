module Abyss

  module Navigation

    class Url

      attr_accessor :name, :title, :options

      def initialize(name, title, options={})
        @name, @title, @options = name, title, options
      end

      def render(rendering_strategy=UnorderedListRenderer.new)
        rendering_strategy.factory(:item, self).render
      end

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
