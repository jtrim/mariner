require 'active_support/core_ext/string/inflections'

module Abyss

  module Navigation

    class UnorderedListRenderer

      attr_accessor :render_titles, :group_classname, :title_classname, :item_classname
      alias :render_titles? :render_titles

      def initialize(opts={})
        defaults.merge(opts).each { |k,v| send("#{k}=", v) }
      end

      def factory(type, subject)
        case type
        when :group then GroupRenderer.new(subject, self)
        when :item then ItemRenderer.new(subject, self)
        end
      end

      private

      def defaults
        { :render_titles => false }
      end

      public

      class ItemRenderer
        include ActionView::Helpers::TagHelper

        attr_accessor :subject, :renderer

        def initialize(subject, renderer)
          @subject, @renderer = subject, renderer
        end

        def render
          content_tag :a, subject.title, render_options
        end

        def render_options
          opts = { :href => subject.href, :class => subject.name.to_s }
          opts.merge(:class => renderer.item_classname, &merge_proc).merge(subject.options, &merge_proc)
        end

        private

        def merge_proc
          proc do |key, oldval, newval|
            case key.to_s
            when "class"
              (oldval.to_s.split(" ") + newval.to_s.split(" ")).sort.join(" ")
            else newval
            end
          end
        end

      end

      class GroupRenderer

        attr_accessor :subject, :renderer

        def initialize(subject, renderer)
          @subject, @renderer = subject, renderer
        end

        def render
          open_surround = close_surround = item_open_surround = item_close_surround = ""

          open_surround = "<ul class='#{renderer.group_classname}'>"
          close_surround = "</ul>"

          item_open_surround = "<li>"
          item_close_surround = "</li>"

          rendered_configurations = subject.configurations.map do |config|
            name, entity = config
            unless subject.virtual?
              "#{item_open_surround}#{entity.render(renderer)}#{item_close_surround}"
            else
              entity.render(renderer)
            end
          end.join

          unless subject.virtual?
            result = ""
            result << open_surround

            if renderer.render_titles?
              result << "<li class='#{renderer.title_classname}'>#{subject.name.to_s.titleize}#{item_close_surround}"
            end

            result << "#{rendered_configurations}#{close_surround}"
          else
            rendered_configurations
          end
        end

      end

    end

  end

end
