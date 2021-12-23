require_relative '../spec_helper'
require 'pry'
require 'securerandom'


RSpec.describe 'GET /locations' do
  api_client = ApiClient.new
  list_of_names = []
  locations = JSON.parse(api_client.locations.body)

  before (:all) do
    locations = JSON.parse(api_client.locations.body)
    list_of_names = locations.map { |l| l['name'] }
  end

  context 'when valid  request' do
    # after(:each) { api_client.locations(type_request: :delete, )}
    random_valid_body = {
      "name": SecureRandom.hex,
      "description": SecureRandom.hex,
    }
    it 'verifies response include all keys of location' do
      new_location = api_client.locations(type_request: :post, body_opts: random_valid_body)
      new_location_name = new_location['name']
      response = api_client.locations(parameter: new_location_name)
      find_location = JSON.parse(response.body)
      binding.pry
      # expect(list_of_names.include?(new_location['name'])).to be_truthy
      expect(new_location.status).to eq(201)
    end

    end
  end
