module Abyss

  module Navigation

    module Renderer

      class Base

        attr_accessor :subject, :rendering_strategy

        def initialize(subject, rendering_strategy)
          @subject, @rendering_strategy = subject, rendering_strategy
        end

      end

    end

  end

end
