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

      class ItemRenderer < Renderer::Base
        include ActionView::Helpers::TagHelper

        def render
          content_tag :a, subject.title, render_options
        end

        def render_options
          opts = { :href => subject.href, :class => subject.name.to_s }
          opts.merge(:class => rendering_strategy.item_classname, &merge_proc).merge(subject.options, &merge_proc)
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

      class GroupRenderer < Renderer::Base

        def render
          open_surround = close_surround = item_open_surround = item_close_surround = ""

          open_surround = "<ul class='#{rendering_strategy.group_classname}'>"
          close_surround = "</ul>"

          item_open_surround = "<li>"
          item_close_surround = "</li>"

          rendered_configurations = subject.configurations.map do |config|
            name, entity = config
            unless subject.virtual?
              "#{item_open_surround}#{entity.render(rendering_strategy)}#{item_close_surround}"
            else
              entity.render(rendering_strategy)
            end
          end.join

          unless subject.virtual?
            result = ""
            result << open_surround

            if rendering_strategy.render_titles?
              result << "<li class='#{rendering_strategy.title_classname}'>#{subject.name.to_s.titleize}#{item_close_surround}"
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
