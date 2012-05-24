require 'active_support/core_ext/string/inflections'

module Mariner

  # Public: The default renderer used. Renders the nav config to
  # an unordered list.
  #
  # Examples:
  #
  #     Mariner.configure do
  #
  #       a_group do
  #         root_path 'A link'
  #       end
  #
  #     end
  #
  #     Mariner.configuration.render #=> returns:
  #
  #     <ul class=''>
  #       <li>
  #         <a class="root_path" href="/">A Link</a>
  #       </li>
  #     </ul>
  #
  #
  # If you want to implement your own rendering strategy, read on
  # for a good starting point.
  #
  #
  #    class FakeRenderingStrategy
  #
  #      # Called from Store and Url instances. Must return something
  #      # that responds to #render
  #      #
  #      def factory(type, subject)
  #        # type - Can be `:group` or `:item`
  #        # subject - The Store or Url instance to render
  #        case type
  #        when :group then FakeRenderingStrategy::GroupRenderer.new(subject, self)
  #        when :item  then FakeRenderingStrategy::ItemRenderer.new(subject, self)
  #        end
  #      end
  #
  #      class GroupRenderer < RenderingStrategy::Base
  #
  #        # A group renderer must iterate its #configurations and call
  #        # #render on each, then return the joined result.
  #        #
  #        def render
  #          subject.configurations.map do |config|
  #            _, entity = config
  #            entity.render(rendering_strategy) # entity can be a Store or a Url
  #          end.join
  #        end
  #
  #      end
  #
  #      class ItemRenderer < RenderingStrategy::Base
  #
  #        # An item renderer just needs to return some string representation
  #        # of the Url it's rendering.
  #        #
  #        def render
  #          # render something based on #subject (e.g. markup for a link)
  #        end
  #
  #      end
  #
  #    end

  class UnorderedListRenderer

    # Public: If true, will render a title list element based
    # on the name of the group.
    #
    attr_accessor :render_titles
    alias :render_titles? :render_titles

    # Public: The classname that will be added to the rendered
    # UL elements.
    #
    attr_accessor :group_classname

    # Public: The classname that will be added to the rendered
    # title LI elements
    #
    attr_accessor :title_classname

    # Public: The classname that will be added to the rendered
    # links (A elements)
    #
    attr_accessor :item_classname

    # Public: Initialize a new renderer with options.
    #
    # options - The hash of options used to determine how to render:
    #           :render_titles - Turn title rendering for Stores on or off (optional, default: false)
    #
    def initialize(options={})
      defaults.merge(options).each { |k,v| send("#{k}=", v) }
    end

    # Public: Called by Store and Url instances to get a renderer.
    #
    # Examples:
    #
    #     s = UnorderedListRenderer.new
    #     s.factory(:group, self) #=> instance of UnorderedListRenderer::GroupRenderer
    #     s.factory(:item, self) #=> instance of UnorderedListRenderer::ItemRenderer
    #
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

      # Public: Renders an A element according to the Url properties.
      #
      def render
        content_tag :a, subject.title, render_options
      end

      # Public: The options that the A element will be rendered with. These
      # are forwarded on to ActionView::Helpers::TagHelper#content_tag
      #
      def render_options
        opts = { :href => subject.href, :class => subject.name.to_s }
        opts.merge(:class => rendering_strategy.item_classname, &merge_proc).merge(subject.options, &merge_proc)
      end

      private

      # Private: Used internally to determine how to merge options. For
      # `:class`, add the values together with a space. For everything else,
      # replace the value.
      #
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

      # Public: Render a Store as an unordererd list HTML element.
      #
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
