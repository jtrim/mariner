module Abyss

  module Navigation

    class Railtie < ::Rails::Railtie

      config.after_initialize do
        Abyss::Navigation::Url.class_eval { include Rails.application.routes.url_helpers }
      end

    end

  end

end
