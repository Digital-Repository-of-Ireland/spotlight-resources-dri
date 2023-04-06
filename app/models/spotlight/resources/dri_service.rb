require 'net/http'
require 'uri'
require 'json'

module Spotlight::Resources
  class DriService

    def self.parse(url, object_ids, metadata = nil)
      response = dri_response(url, object_ids, metadata)
      json = JSON.parse(response)

      create_dri_objects(json)
    end


    private
      class << self
        def dri_response(url, object_ids, metadata = nil)
          request_params = { objects: object_ids.map { |id| { pid: id } } }
          request_params[:metadata] = metadata.split(/[,\s]+/) if metadata

          uri = URI.parse(url)
          response = Net::HTTP.new(uri.host, uri.port)
          http = Net::HTTP.new(uri.host, uri.port)

          if uri.scheme == "https"
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          end

          request = Net::HTTP::Post.new(
            uri.request_uri,
            {'Content-Type': 'application/json'}
          )
          request.body = request_params.to_json
          http.request(request).body
        end

        private

        def create_dri_objects(objects_json)
          objects_json.select{ |o| o.is_a?(Hash) && o.key?('pid') }.map do |object_json|
            object = Spotlight::Resources::DriObject.new(
              id: object_json['pid'],
              metadata: object_json['metadata'],
              files: object_json['files']
            )
          end
        end
      end
  end
end
