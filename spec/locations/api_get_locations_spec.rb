require_relative '../spec_helper'
require 'securerandom'

RSpec.describe 'GET /locations' do
  api_client = ApiClient.new
  locations = JSON.parse(api_client.locations.body)

  before (:all) do
    locations = JSON.parse(api_client.locations.body)
  end

  context 'when valid  request' do
    it 'verifies response include all keys of locations' do
      response = api_client.locations
      locations = JSON.parse(response.body)
      expect(locations.each { |elem| elem.has_key?('id' && 'name' && 'description') }).to be_truthy
      expect(response.status).to eq(200)
    end

    it 'verifies return location by name' do
      location = locations.sample
      location_name = location['name']
      response = api_client.locations(parameter: location_name)
      find_location = JSON.parse(response.body)
      expect(find_location['name']).to eq(location_name)
      expect(find_location['description']).to eq(location['description'])
      expect(response.status).to eq(200)
    end
  end

  context 'when authorized user' do
    invalid_names = {
      random_name: SecureRandom.hex(10),
      less_2_symbols: SecureRandom.hex(1),
      more_1000_symbols: SecureRandom.hex(1001)
      #empty: ''
    }

    invalid_names.each do |invalid_type, value|
      it "verifies with #{invalid_type} name returns status code 404" do
        response = api_client.locations(parameter: value)
        expect(response.reason_phrase).to eq('Not Found')
        expect(response.body).to include('Location Not Found')
        expect(response.status).to eq(404)
      end
    end

    it 'verifies with deleted name returns status code 404' do
      random_location = locations.sample
      name_for_delete = random_location['name']
      new_locations_list = locations.delete_if { |elem| elem.has_value?(name_for_delete) }
      new_location = new_locations_list.sample
      api_client.locations(type_request: :delete, parameter: name_for_delete, body_opts: { "new_name": new_location['name'] })
      response = api_client.locations(parameter: name_for_delete)
      expect(response.reason_phrase).to eq('Not Found')
      expect(response.body).to include('Location Not Found')
      expect(response.status).to eq(404)
    end

    it 'verifies with updated name returns status code 404' do
      random_location = locations.sample
      name_for_update = random_location['name']
      new_locations_name = SecureRandom.hex(10)
      api_client.locations(type_request: :patch, parameter: name_for_update, body_opts: { "new_name": new_locations_name })
      response = api_client.locations(parameter: random_location['name'])
      expect(response.reason_phrase).to eq('Not Found')
      expect(response.body).to include('Location Not Found')
      expect(response.status).to eq(404)
    end
  end

  it_behaves_like 'non-authorized user', api_client
end
