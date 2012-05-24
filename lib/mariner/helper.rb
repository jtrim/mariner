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
    def render_navigation(config_path=nil, renderer=nil)
      path   = config_path ? config_path.to_s.split("/") : []
      target = path.reduce(Mariner.configuration) { |acc, g| acc.send g }

      if renderer && renderer.respond_to?(:render)
        target.render(renderer)
      elsif renderer && Mariner.rendering_strategies[renderer].nil?
        raise "Rendering strategy not found: #{renderer}"
      elsif renderer
        target.render(Mariner.rendering_strategies[renderer])
      else
        target.render
      end
    end

  end

end
