module Spotlight
  module Resources
    class DriHarvester < Spotlight::Resource
      attr_accessor :ids, :base_url, :user, :token

      def dri_objects
        @dri_objects ||= retrieve_objects
      end

      def object_ids
        @object_ids ||= self.data[:ids].split(/\s+/)
      end

      def retrieve_objects
        url = self.data[:base_url] + "/get_objects.json?user_email=" + self.data[:user] + "&user_token=" + self.data[:token]

        DriService.parse(url, object_ids)
      end
      
      def self.indexing_pipeline
        @indexing_pipeline ||= super.dup.tap do |pipeline|
          pipeline.sources = [Spotlight::Etl::Sources::SourceMethodSource(:dri_objects)]

          pipeline.transforms = [
            ->(data, p) { data.merge(p.source.to_solr(exhibit: p.context.resource.exhibit)) }
          ] + pipeline.transforms
        end
      end
    end
  end
end
