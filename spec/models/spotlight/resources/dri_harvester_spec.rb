require 'rails_helper'
require 'yaml'

RSpec.describe Spotlight::Resources::DriHarvester, type: :model do
  let(:exhibit) { FactoryBot.create(:exhibit) }
  let(:harvester) { described_class.create(exhibit_id: exhibit.id,
     data: {base_url: 'https://repository.dri.ie', user: 'manager@dri.ie', token: 'token', ids: "xxxxxx"})}

  describe 'Harvesting' do
    let(:url) { 'https://repository.dri.ie/get_objects?user_email=manager@dri.ie&user_token=token' }

    subject { harvester }
    before { stub_default_collection }

    it 'returns DRIObjects' do
      expect(subject.dri_objects.first).to be_instance_of(Spotlight::Resources::DriObject)
    end
  end

  describe '#documents_to_index' do
    let(:url) { 'https://repository.dri.ie/get_objects?user_email=manager@dri.ie&user_token=token' }
    before { stub_default_collection }
    subject { harvester.document_builder }

    it 'returns an Enumerator of all the solr documents' do
      expect(subject.documents_to_index).to be_a(Enumerator)
      expect(subject.documents_to_index.count).to eq 1
    end

    it 'all solr documents include exhibit context' do
      subject.documents_to_index.each do |doc|
        expect(doc).to have_key("spotlight_exhibit_slug_#{exhibit.slug}_bsi")
      end
    end
  end

end

