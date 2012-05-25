module Mariner

  # Private: After Rails initializes:
  # * mixes `Rails.application.routes.url_helpers` into Mariner::Url
  # * includes Mariner::Helper into ActionController::Base
  # * makes a #helper_method out of Helper#render_navigation
  #
  class Railtie < ::Rails::Railtie

    config.after_initialize do
      Mariner::Url.class_eval { include Rails.application.routes.url_helpers }

      ActiveSupport.on_load(:action_controller) do
        include Mariner::Helper
        helper_method :render_navigation, :render_sub_navigations
      end
    end

  end

end
