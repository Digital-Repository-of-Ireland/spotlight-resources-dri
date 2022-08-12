require 'spec_helper'
require 'yaml'

RSpec.describe Spotlight::Resources::DriObject, type: :model do
  let(:exhibit) { FactoryBot.create(:exhibit) }
  let(:object_json) { JSON.parse(file_fixture('object.json').read).first }


  subject(:object) { described_class.new(
              id: object_json['pid'],
              metadata: object_json['metadata'],
              files: object_json['files']
            )}

  describe '#to_solr' do

    describe 'id' do
      it 'is an MD5 hexdigest of the exhibit id and the and the url' do
        expected = Digest::MD5.hexdigest("#{exhibit.id}-#{object_json['pid']}")
        expect(subject.to_solr(exhibit: exhibit)[:id]).to eq expected
      end
    end

    describe 'label' do
      it 'is included in the solr document when present' do
        expect(subject.to_solr(exhibit: exhibit)['full_title_tesim']).to eq ["They Remember 1916: Joseph O'Connor"]
      end
    end

    describe "collection id" do
      it "is included when a collection is given" do
        expected = Digest::MD5.hexdigest("#{exhibit.id}-#{object_json['metadata']['isGovernedBy']}")
        expect(subject.to_solr(exhibit: exhibit)[:collection_id_ssim]).to eq [expected]
      end
    end

    describe 'image urls' do
      it 'is included in the solr document when present' do
        expect(subject.to_solr(exhibit: exhibit)[:content_metadata_image_iiif_info_ssm]).to eq ['https://repository.dri.ie/loris/n871c555k:tm7118916/info.json']
      end
    end

  end
end
