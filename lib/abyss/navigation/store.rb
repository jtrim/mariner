require 'active_support/core_ext/string/inflections'

module Abyss

  module Navigation

    class Store < ::Abyss::DeepStore

      def assign(method_name, values)
        raise ArgumentError, "Wrong number of values specified (#{values.size} for <= 2)" if values.size > 2

        values[1] ||= {} # link options
        title, options = values
        self.configurations[method_name] = Url.new(method_name, title, options)
      end

      def render(opts={})
        open_surround = close_surround = item_open_surround = item_close_surround = ""

        open_surround = "<ul class='navigation-group #{self.name}'>"
        close_surround = "</ul>"
        item_open_surround = "<li>"
        item_close_surround = "</li>"

        rendered_configurations = configurations.map { |config| name, entity = config; "#{item_open_surround}#{entity.render(opts)}#{item_close_surround}" }.join

        result = ""

        result << open_surround
        result << "#{item_open_surround}#{self.name.to_s.titleize}#{item_close_surround}" if opts[:include_title] && !name.nil?
        result << "#{rendered_configurations}#{close_surround}"

        result
      end

    end

  end

end
