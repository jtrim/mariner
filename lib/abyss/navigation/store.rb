module Abyss

  module Navigation

    class Store < ::Abyss::DeepStore

      def assign(method_name, values)
        raise ArgumentError, "Wrong number of values specified (#{values.size} for <= 2)" if values.size > 2

        values[1] ||= {} # link options
        title, options = values
        self.configurations[method_name] = Url.new(method_name, title, options)
      end

      def render(name=nil)
        open_surround = close_surround = item_open_surround = item_close_surround = ""

        if name.present?
          open_surround = "<ul class='navigation-group #{name}'>"
          close_surround = "</ul>"
          item_open_surround = "<li>"
          item_close_surround = "</li>"
        end

        rendered_configurations = configurations.map { |config| name, entity = config; "#{item_open_surround}#{entity.render(name)}#{item_close_surround}" }.join
        "#{open_surround}#{rendered_configurations}#{close_surround}"
      end

    end

  end

end
