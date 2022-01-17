require_relative 'spec_helper'

RSpec.shared_examples 'invalid post request' do
  [{ test_type: 'name and invalid description', name: SecureRandom.alphanumeric(100), description: SecureRandom.alphanumeric(4) },
   { test_type: 'invalid name and description', name: SecureRandom.alphanumeric(1001), description: SecureRandom.alphanumeric(100) },
   { test_type: 'invalid both name and description', name: SecureRandom.alphanumeric(1001), description: SecureRandom.alphanumeric(3) }
  ].each do |data|
    it "verifies #{data[:test_type]} response status code is 400" do
      all_locations_before_post = JSON.parse(api_client.locations.body)
      response = api_client.locations(type_request: :post, body_opts: { "name": data[:name], "description": data[:description] })
      all_locations_after_post = JSON.parse(api_client.locations.body)
      expect(all_locations_before_post).to eq(all_locations_after_post)
    end
  end
end

RSpec.shared_examples 'invalid patch request' do
   { empty_name: '',
    less_2_symbols: SecureRandom.hex(1),
    more_1000_symbols: SecureRandom.hex(1001)
  }.each do |invalid_type, value|
    it "verifies with #{invalid_type} name returns status code 404" do
      name_for_update = random_location['name']
      response = api_client.locations(type_request: :patch, parameter: name_for_update, body_opts: { "new_name": value })
      expect(response.reason_phrase).to eq('Bad Request')
      expect(response.status).to eq(400)
    end
  end
end

