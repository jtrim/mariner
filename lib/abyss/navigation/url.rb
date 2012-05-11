module Abyss

  module Navigation

    class Url

      include ActionView::Helpers::TagHelper

      attr_accessor :name, :title, :link_options

      def initialize(name, title, link_options={})
        @name, @title, @link_options = name, title, link_options
      end

      def render(*)
        content_tag :a, title, render_options
      end

      private

      def href
        begin
          send(name)
        rescue NoMethodError => e
          raise ::Abyss::Errors::InvalidUrlHelperMethod.new(name)
        end
      end

      def render_options
        opts = { href: href, class: name }
        opts.merge(link_options) do |key, oldval, newval|
          case key.to_s
          when "class"
            (oldval.to_s.split(" ") + newval.to_s.split(" ")).sort.join(" ")
          else newval
          end
        end
      end

    end

  end

end
