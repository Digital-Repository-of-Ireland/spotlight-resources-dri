require 'spec_helper'
require 'yaml'

RSpec.describe Spotlight::Resources::DriHarvester, type: :model do
  let(:exhibit) { FactoryBot.create(:exhibit) }
  subject(:harvester) { described_class.create(exhibit_id: exhibit.id,
     data: {base_url: 'https://repository.dri.ie', user: 'manager@dri.ie', token: 'token', ids: "xxxxxx"})}

  describe 'Harvesting' do
    let(:url) { 'https://repository.dri.ie/get_objects.json?user_email=manager@dri.ie&user_token=token' }

    before { stub_default_collection }

    it 'returns DRIObjects' do
      expect(subject.dri_objects.first).to be_instance_of(Spotlight::Resources::DriObject)
    end
  end

  describe '#reindex' do
    let(:url) { 'https://repository.dri.ie/get_objects.json?user_email=manager@dri.ie&user_token=token' }
    before do
      stub_default_collection
      allow(Spotlight::Engine.config).to receive(:writable_index).and_return(false)
    end

    it 'indexes all the solr documents' do
      expect(subject.reindex).to eq 1
    end
  end
end

