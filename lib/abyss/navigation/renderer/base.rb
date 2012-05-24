module Abyss

  module Navigation

    module Renderer

      # Public: The base class for renderers used in a rendering strategy.
      #
      # Examples:
      #
      #     class FakeRenderingStrategy
      #
      #       def factory(type, subject)
      #         case type
      #         when :group then FakeRenderer.new(subject, self)
      #         ...
      #
      #       class FakeRenderer < Abyss::Navigation::Renderer::Base
      #
      #         def render
      #           ...
      #
      class Base

        # Public: The subject (a Store or a Url) to render
        #
        attr_accessor :subject

        # Public: The rendering strategy used that responds to #factory
        #
        attr_accessor :rendering_strategy

        # Public: Creates a new renderer and assigns #subject and
        # #rendering_strategy
        #
        def initialize(subject, rendering_strategy)
          @subject, @rendering_strategy = subject, rendering_strategy
        end

      end

    end

  end

end
