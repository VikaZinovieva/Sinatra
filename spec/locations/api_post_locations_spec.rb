require_relative '../spec_helper'
require 'securerandom'

RSpec.describe 'POST/locations' do
  let(:api_client) { ApiClient.new }

  context 'when valid  request' do
    random_valid_body = {
      "name": SecureRandom.alphanumeric(1000),
      "description": SecureRandom.alphanumeric(1000),
    }

    it 'verifies create location' do
      new_location = api_client.locations(type_request: :post, body_opts: random_valid_body)
      posted_location = JSON.parse(api_client.locations(parameter: random_valid_body[:name]).body)
      expect(new_location.status).to eq(200)
      expect(posted_location['description']).to eq(random_valid_body[:description])

    end

  end

  it_behaves_like 'non-authorized user'
  it_behaves_like 'invalid post request'
end
