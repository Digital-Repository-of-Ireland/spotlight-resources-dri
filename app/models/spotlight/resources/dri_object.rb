module Spotlight
  module Resources
    ##
    # A PORO to construct a solr hash for a given Dri Object json
    class DriObject
      attr_reader :collection
      def initialize(attrs = {})
        @id = attrs[:id]
        @metadata = attrs[:metadata]
        @files = attrs[:files]
        @solr_hash = {}
      end

      def to_solr
        add_document_id
        add_label
        add_creator
        add_type
        add_metadata
        add_collection_id
        add_image_urls
        solr_hash
      end

      def with_exhibit(e)
        @exhibit = e
      end

      def compound_id(id)
        Digest::MD5.hexdigest("#{exhibit.id}-#{id}")
      end

      private

      attr_reader :id, :exhibit, :metadata, :files, :solr_hash
      delegate :blacklight_config, to: :exhibit

      def add_creator
        solr_hash['readonly_creator_ssim'] = metadata['creator']
      end

      def add_type
        solr_hash['readonly_type_ssim'] = metadata['type']
      end

      def add_document_id
        solr_hash[blacklight_config.document_model.unique_key.to_sym] = compound_id(id)
      end

      def add_collection_id
        if metadata.key?('isGovernedBy')
          solr_hash[collection_id_field] = [compound_id(metadata['isGovernedBy'])]
        end
      end

      def collection_id_field
        :collection_id_ssim
      end

      def add_image_urls
        solr_hash[tile_source_field] = image_urls
      end

      def add_label
        return unless title_field && metadata.key?('title')
        solr_hash[title_field] = metadata['title']
      end

      def add_metadata
        solr_hash.merge!(object_metadata)
        sidecar.update(data: sidecar.data.merge(object_metadata))
      end

      def object_metadata
        item_metadata = metadata_class.new(metadata).to_solr
        return {} unless metadata.present?
        create_sidecars_for(*item_metadata.keys)

        item_metadata.each_with_object({}) do |(key, value), hash|
          next unless (field = exhibit_custom_fields[key])
          hash[field.field] = value
        end
      end

      def create_sidecars_for(*keys)
        missing_keys(keys).each do |k|
          exhibit.custom_fields.create! label: k, readonly_field: true
        end
        @exhibit_custom_fields = nil
      end

      def missing_keys(keys)
        custom_field_keys = exhibit_custom_fields.keys.map(&:downcase)
        keys.reject do |key|
          custom_field_keys.include?(key.downcase)
        end
      end

      def exhibit_custom_fields
        @exhibit_custom_fields ||= exhibit.custom_fields.each_with_object({}) do |value, hash|
          hash[value.label] = value
        end
      end

      def iiif_manifest_base
        Spotlight::Resources::Dri::Engine.config.iiif_manifest_base
      end

      def image_urls
        @image_urls ||= files.map do |file|
          # skip unless it is an image
          next unless file && file.key?(surrogate_postfix)

          file_id = File.basename(
                      URI.parse(file[surrogate_postfix]).path
                    ).split("_#{surrogate_postfix}")[0]

          "#{iiif_manifest_base}/#{id}:#{file_id}/info.json"
        end.compact
      end

      def thumbnail_field
        blacklight_config.index.try(:thumbnail_field)
      end

      def tile_source_field
        blacklight_config.show.try(:tile_source_field)
      end

      def title_field
        blacklight_config.index.try(:title_field)
      end

      def sidecar
        @sidecar ||= document_model.new(id: compound_id(id)).sidecar(exhibit)
      end

      def surrogate_postfix
        Spotlight::Resources::Dri::Engine.config.surrogate_postfix
      end

      def document_model
        exhibit.blacklight_config.document_model
      end

      def metadata_class
        Spotlight::Resources::DriObject::Metadata
      end

      ###
      #  A simple class to map the metadata field
      #  in an object to label/value pairs
      #  This is intended to be overriden by an
      #  application if a different metadata
      #  strucure is used by the consumer
      class Metadata
        def initialize(metadata)
          @metadata = metadata
        end

        def to_solr
          metadata_hash.merge(descriptive_metadata)
        end

        private

        attr_reader :metadata

        def metadata_hash
          return {} unless metadata.present?
          return {} unless metadata.is_a?(Array)

          metadata.each_with_object({}) do |md, hash|
            next unless md['label'] && md['value']
            hash[md['label']] ||= []
            hash[md['label']] += Array(md['value'])
          end
        end

        def descriptive_metadata
          desc_metadata_fields.each_with_object({}) do |field, hash|
            if field == 'attribution'
              add_attribution(field, hash)
              next
            end

            next unless metadata[field].present?
            hash[field.capitalize] ||= []
            hash[field.capitalize] += Array(metadata[field])
          end
        end

        def desc_metadata_fields
          %w(description creator attribution rights license)
        end

        def add_attribution(field, hash)
          return unless metadata.key?('institute')

          hash[field.capitalize] ||= []
          metadata['institute'].each do |institute|
            hash[field.capitalize] += Array(institute['name'])
          end
        end
      end
    end
  end
end
