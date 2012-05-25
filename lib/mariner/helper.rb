module Mariner

  # Public: Gets included in controllers (see the Railtie)
  #
  module Helper

    # Public: A shortcut for rendering navigation. Made available to both
    # controllers and views.
    #
    # config_path - A symbol or slash-separated string path to the
    # configuration group you want to render.
    #
    # renderer - The rendering strategy to use.
    # Can be a symbol or actual
    # rendering stragey.  When a symbol, looks in the
    # `Mariner.rendering_strategies` hash using the given symbol as the key.
    # Raises an error if not found.  When a rendering strategy, passes the
    # strategy on to the target group's #render method.
    #
    # Examples:
    #
    #     Mariner.configure do
    #       a_group do
    #         root_path "Home"
    #
    #         a_sub_group do
    #           users_path "Manage Users"
    #         end
    #       end
    #     end
    #
    #     render_navigation
    #     #=> renders the entire nav tree
    #
    #     render_navigation :a_group
    #     #=> renders the `a_group` nav tree
    #
    #     render_navigation "a_group/a_sub_group"
    #     #=> renders the nav tree of `a_sub_group` under `a_group`
    #
    #     render_navigation :a_group, FakeRenderingStrategy.new
    #     #=> renders `a_group` with a FakeRenderingStrategy instance
    #
    #     render_navigation :a_group, :other_strategy
    #     #=> renders `a_group` with Mariner.rendering_strategies[:other_strategy]
    #
    def render_navigation(config_path=nil, renderer=nil)
      target   = target_from_path(config_path)
      strategy = rendering_strategy_from(renderer)

      strategy ? target.render(strategy) : target.render
    end

    # Public: For when you want to render all the configurations under
    # a given group but you don't want to render the group itself.
    #
    # Examples:
    #
    #     Mariner.configure do
    #       group_a do
    #         root_path "Home"
    #       end
    #
    #       group_b do
    #         users_path "Manage Users"
    #       end
    #     end
    #
    #     render_sub_navigations
    #     #=> renders the group_a and group_b trees and joins the result
    #
    def render_sub_navigations(config_path=nil, renderer=nil)
      target = target_from_path(config_path)
      strategy = rendering_strategy_from(renderer)

      target.configurations.map do |c|
        _, entity = c
        strategy ? entity.render(strategy) : entity.render
      end.join
    end

    private

    def target_from_path(config_path)
      path   = config_path ? config_path.to_s.split("/") : []
      path.reduce(Mariner.configuration) { |acc, g| acc.send g }
    end

    def rendering_strategy_from(renderer)
      return nil unless renderer
      return renderer if renderer && renderer.respond_to?(:render)
      raise "Rendering strategy not found: #{renderer}" if Mariner.rendering_strategies[renderer].nil?

      Mariner.rendering_strategies[renderer]
    end

  end

end
