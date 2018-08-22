require 'rails_helper'
require 'yaml'

RSpec.describe Spotlight::Resources::DriService, type: :model do
  let(:exhibit) { FactoryBot.create(:exhibit) }

  describe '#parse' do
    let(:url) { 'https://repository.dri.ie/get_objects?user_email=manager@dri.ie&user_token=token' }
    let(:object_ids) { ['xxxxxx'] }

    before { stub_default_collection }

    it 'returns DRIObjects' do
      expect(described_class.parse(url, object_ids).first).to be_instance_of(Spotlight::Resources::DriObject)
    end
  end

end
