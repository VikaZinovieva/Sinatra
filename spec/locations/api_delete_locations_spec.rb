require_relative '../spec_helper'
require 'securerandom'

RSpec.describe 'DELETE/locations' do
  api_client = ApiClient.new
  locations = JSON.parse(api_client.locations.body)

  context 'when valid request' do
    it 'verifies delete location returns status code 200' do
      random_location = locations.sample #sample employees, get location from record employee
      name_for_delete = random_location['name']
      new_location = locations.sample
      deleted_location = api_client.locations(type_request: :delete, parameter: name_for_delete, body_opts: { "new_name": new_location['name'] })
      response = api_client.locations(parameter: name_for_delete)
      expect(response.reason_phrase).to eq('Not Found')
      expect(response.body).to include('Location Not Found')
      expect(deleted_location.status).to eq(200)
    end
  end

  context 'when authorized user' do
    it 'verifies delete location non-exist in database returns status code 400' do
      random_location = SecureRandom.alphanumeric(15)
      exist_location = locations.sample
      response = api_client.locations(type_request: :delete, parameter: random_location, body_opts: {"new_name": exist_location['name'] })
      expect(response.status).to eq(400)
      expect(response.body).to include('Location Not Deleted')
      expect(response.reason_phrase).to eq('Bad Request')
    end

    it 'verifies delete location name and new_name are same returns status code 400' do
      random_location = locations.sample #sample employees, get location from record employee
      name_for_delete = random_location['name']
      response = api_client.locations(type_request: :delete, parameter: name_for_delete, body_opts: { "new_name": name_for_delete })
      expect(response.status).to eq(500)
    end

  end
end
