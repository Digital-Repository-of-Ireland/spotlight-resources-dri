require 'fixtures/dri_responses'
module StubDriResponse
  def stub_dri_response_for_url(url, params, response)
    allow(Spotlight::Resources::DriService).to receive(:dri_response).with(url, params).and_return(response)
  end

  def stub_default_collection
    stub_dri_response_for_url(
      'https://repository.dri.ie/get_objects?user_email=manager@dri.ie&user_token=token',
      ["xxxxxx"],
      object_json
    )
  end
end

RSpec.configure do |config|
  config.include DriResponses
  config.include StubDriResponse
end
