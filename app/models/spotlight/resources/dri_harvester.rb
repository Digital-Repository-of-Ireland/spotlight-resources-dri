module Spotlight
  module Resources
    class DriHarvester < Spotlight::Resource
      attr_accessor :ids, :base_url, :user, :token
      self.document_builder_class = Spotlight::Resources::DriBuilder

      def dri_objects
        @dri_objects ||= retrieve_objects
      end

      def object_ids
        @object_ids ||= self.data[:ids].split(/\s+/)
      end

      def retrieve_objects
        url = self.data[:base_url] + "/get_objects?user_email=" + self.data[:user] + "&user_token=" + self.data[:token]

        DriService.parse(url, object_ids)
      end

    end
  end
end
