require 'active_support/core_ext/string/inflections'

module Mariner

  # Public: Uses the Abyss library to provide arbitrarily-deep sets of
  # navigation groups / urls. Think of this as the group when
  # defining nav trees.
  #
  # Examples:
  #
  #     Mariner.configure do
  #
  #       a_group do         # <= This effectivly creates a new Mariner::Store, ...
  #         root_path "Home" # <= and this creates a new Mariner::Url within said store.
  #       end
  #
  #     end
  #
  class Store < ::Abyss::DeepStore

    # Public: If the group is virtual, the rendering strategy shouldn't
    # generate any output around its nested configurations when.
    # e.g. The UnorderedListRenderer doesn't generate `ul` or `li` tags when
    # the target group is virtual.
    #
    attr_accessor :virtual
    alias :virtual? :virtual

    # Public: Sets virtual to false by default and defers to
    # ::Abyss::DeepStore for initialization.
    #
    def initialize(*)
      @virtual = false
      super
    end

    # Public: Abstract method override - overrides ::Abyss::DeepStore#assign
    # to store Urls. This is only called when NOT dealing with a nested
    # group.
    #
    # e.g.:
    #
    #     Mariner.configure do
    #
    #       a_group do
    #         root_path "Home" # <= #assign gets called.
    #       end
    #
    #     end
    #
    def assign(method_name, values)
      raise ArgumentError, "Wrong number of values specified (#{values.size} for <= 2)" if values.size > 2

      values[1] ||= {} # link options
      title, options = values
      self.configurations[method_name] = Url.new(method_name, title, options)
    end

    # Public: Uses a rendering strategy to render itself.
    #
    # rendering_strategy - The rendering strategy to use when rendering.
    #
    # Examples:
    #
    #     Mariner.configuration #=> An Mariner::Store instance
    #
    #     Mariner.configuration.render
    #     Mariner.configuration.render(SomeRenderingStrategy.new)
    #
    def render(rendering_strategy=Mariner.rendering_strategies[:default])
      rendering_strategy.factory(:group, self).render
    end

  end

end
