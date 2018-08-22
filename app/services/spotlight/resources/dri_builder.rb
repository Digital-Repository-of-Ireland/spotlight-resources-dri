module Spotlight
  module Resources
    # transforms a DriHarvester into solr documents
    class DriBuilder < Spotlight::SolrDocumentBuilder

      def to_solr
        return to_enum(:to_solr) { 0 } unless block_given?

        base_doc = super
        resource.dri_objects.each do |object|
          object.with_exhibit(exhibit)
          object_solr = object.to_solr
          yield base_doc.merge(object_solr) if object_solr.present?
        end
      end

    end
  end
end
