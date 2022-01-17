require_relative '../spec_helper'
require 'securerandom'
require 'pry'

RSpec.describe 'PATCH/locations' do
  let(:api_client) { ApiClient.new }
  let(:random_location) { JSON.parse(api_client.locations.body).sample }


  context 'when valid request' do
    it 'verifies updated location with new name' do
      name_for_update = random_location['name']
      new_locations_name = SecureRandom.hex(10)
      # binding.pry
      patch_response = api_client.locations(type_request: :patch, parameter: name_for_update, body_opts: { "new_name": new_locations_name })
      response = api_client.locations(parameter: new_locations_name) # get with old name status 400
      get_response_old_name = api_client.locations(parameter: name_for_update)
      expect(get_response_old_name.status).to eq(404)
      expect(patch_response.reason_phrase).to eq('OK')
      expect(response.status).to eq(200)
      expect(patch_response.status).to eq(200)
    end

  end

  it_behaves_like 'invalid patch request'
  it_behaves_like 'non-authorized user'
end
