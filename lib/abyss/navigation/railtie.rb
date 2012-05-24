module Abyss

  module Navigation

    # Private: After Rails initializes:
    # * mixes `Rails.application.routes.url_helpers` into Abyss::Navigation::Url
    # * includes Abyss::Navigation::Helper into ActionController::Base
    # * makes a #helper_method out of Helper#render_navigation
    #
    class Railtie < ::Rails::Railtie

      config.after_initialize do
        Abyss::Navigation::Url.class_eval { include Rails.application.routes.url_helpers }

        ActiveSupport.on_load(:action_controller) do
          include Abyss::Navigation::Helper
          helper_method :render_navigation
        end
      end

    end

  end

end
