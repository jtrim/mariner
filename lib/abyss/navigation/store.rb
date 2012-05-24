require 'active_support/core_ext/string/inflections'

module Abyss

  module Navigation

    class Store < ::Abyss::DeepStore

      attr_accessor :virtual
      alias :virtual? :virtual

      def initialize(*)
        @virtual = false
        super
      end

      # ABSTRACT METHOD OVERRIDE
      #
      def assign(method_name, values)
        raise ArgumentError, "Wrong number of values specified (#{values.size} for <= 2)" if values.size > 2

        values[1] ||= {} # link options
        title, options = values
        self.configurations[method_name] = Url.new(method_name, title, options)
      end

      def render(rendering_strategy=UnorderedListRenderer.new)
        rendering_strategy.factory(:group, self).render
      end

    end

  end

end
