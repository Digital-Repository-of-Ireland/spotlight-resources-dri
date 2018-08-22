require 'rails/generators'

module Spotlight
  module Resources
    module Dri
      # :nodoc:
      class InstallGenerator < Rails::Generators::Base
        desc 'This generator mounts the Spotlight::Resources::Dri::Engine engine'

        def inject_spotlight_dri_resources_routes
          route "mount Spotlight::Resources::Dri::Engine, at: 'spotlight_dri_resources'"
        end
      end
    end
  end
end
