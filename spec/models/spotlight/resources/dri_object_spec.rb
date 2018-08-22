require 'rails_helper'
require 'yaml'

RSpec.describe Spotlight::Resources::DriObject, type: :model do
  let(:exhibit) { FactoryBot.create(:exhibit) }
  let(:object_json) { JSON.parse(file_fixture('object.json').read).first }


  subject(:object) { described_class.new(
              id: object_json['pid'],
              metadata: object_json['metadata'],
              files: object_json['files']
            )}

  before do
    subject.with_exhibit(exhibit)
  end

  describe '#to_solr' do

    describe 'id' do
      it 'is an MD5 hexdigest of the exhibit id and the and the url' do
        expected = Digest::MD5.hexdigest("#{exhibit.id}-#{object_json['pid']}")
        expect(subject.to_solr[:id]).to eq expected
      end
    end

    describe 'label' do
      it 'is inlcuded in the solr document when present' do
        expect(subject.to_solr['full_title_tesim']).to eq ["They Remember 1916: Joseph O'Connor"]
      end
    end

    describe "collection id" do
      it "is included when a collection is given" do
        expected = Digest::MD5.hexdigest("#{exhibit.id}-#{object_json['metadata']['isGovernedBy']}")
        expect(subject.to_solr[:collection_id_ssim]).to eq [expected]
      end
    end

    describe 'image urls' do
      it 'is included in the solr document when present' do
        expect(subject.to_solr[:content_metadata_image_iiif_info_ssm]).to eq ['https://repository.dri.ie/loris/n871c555k:tm7118916_full_size_web_format.jpeg/info.json']
      end
    end

    describe 'metadata' do
      it 'collects items with the same label into an array' do
        expect(subject.to_solr['readonly_subject_tesim']).to eq ["Ireland--History--Easter Rising, 1916", "Curated Collection--Impact of the Rising", "Paramilitary forces--Irish Volunteers", "Revolutionaries", "Curated Collection--Remembering the Rising"]
      end
    end

  end
end
