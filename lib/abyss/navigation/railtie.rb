module Abyss

  module Navigation

    # Private: After Rails initializes, mixes
    # `Rails.application.routes.url_helpers` into Abyss::Navigation::Url
    #
    class Railtie < ::Rails::Railtie

      config.after_initialize do
        Abyss::Navigation::Url.class_eval { include Rails.application.routes.url_helpers }
      end

    end

  end

end
