require 'spotlight/engine'

module Spotlight
  module Resources
    module Dri
      class Engine < ::Rails::Engine
        Spotlight::Resources::Dri::Engine.config.metadata_class = -> { Spotlight::Resources::DriObject::Metadata }
        Spotlight::Resources::Dri::Engine.config.resource_partial = 'spotlight/resources/dri_harvester/form'

        initializer 'spotlight.dri.initialize' do
          Spotlight::Engine.config.external_resources_partials ||= []
          Spotlight::Engine.config.external_resources_partials << Spotlight::Resources::Dri::Engine.config.resource_partial
        end
        config.generators do |g|
          g.test_framework :rspec
        end
      end
    end
  end
end
