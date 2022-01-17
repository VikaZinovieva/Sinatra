require_relative 'spec_helper'

RSpec.shared_examples 'invalid get request' do |endpoint|
  invalid_names = {
    random_name: SecureRandom.hex(10),
    less_2_symbols: SecureRandom.hex(1),
    more_1000_symbols: SecureRandom.hex(1001)
  }

  invalid_names.each do |invalid_type, value|
    it "verifies with #{invalid_type} name returns status code 404" do
      response = api_client.company_request(endpoint: endpoint, parameter: value)
      expect(response.reason_phrase).to eq('Not Found')
      expect(response.status).to eq(404)
    end
  end
end

RSpec.shared_examples 'invalid post request' do |endpoint|
  random_name = JSON.parse(ApiClient.new.company_request(endpoint: endpoint).body).sample
  [{ test_type: 'name and invalid description', name: SecureRandom.alphanumeric(100), description: SecureRandom.alphanumeric(4) },
   { test_type: 'invalid name and description', name: SecureRandom.alphanumeric(1001), description: SecureRandom.alphanumeric(100) },
   { test_type: 'invalid both name and description', name: SecureRandom.alphanumeric(1001), description: SecureRandom.alphanumeric(3) },
   { test_type: 'exists in database name', name: random_name["name"], description: SecureRandom.alphanumeric(3) },
   { test_type: 'empty name and description', name: '', description: '' }
  ].each do |data|
    it "verifies #{data[:test_type]} don't save record in database" do
      all_before_post = JSON.parse(api_client.company_request(endpoint: endpoint).body)
      response = api_client.company_request(type_request: :post, endpoint: endpoint, body_opts: { "name": data[:name], "description": data[:description] })
      all_after_post = JSON.parse(api_client.company_request(endpoint: endpoint).body)
      expect(all_before_post).to eq(all_after_post)
      expect(response.status).to eq(200)
    end
  end
end

RSpec.shared_examples 'invalid patch request' do |endpoint|
  { less_2_symbols: SecureRandom.hex(1),
    more_1000_symbols: SecureRandom.hex(1001),
    empty: ''
  }.each do |invalid_type, value|
    it "verifies with #{invalid_type} name returns status code 404" do
      name_for_update = random_name['name']
      api_client.company_request(type_request: :patch, endpoint: endpoint, parameter: name_for_update, body_opts: { "new_name": value })
      response = api_client.company_request(endpoint: endpoint, parameter: value)
      response_for_random_name = api_client.company_request(endpoint: endpoint, parameter: name_for_update)
      expect(response_for_random_name.status).to eq(200)
      expect(response_for_random_name.body).not_to be_empty
      expect(response.status).to eq(404)
    end
  end
end

RSpec.shared_examples 'invalid delete request' do |endpoint, id_of|
  it "verifies delete #{endpoint} non-exist in database returns status code 400" do
    random_location = SecureRandom.alphanumeric(15)
    exist_location = all_records.sample
    response = api_client.company_request(type_request: :delete, endpoint: endpoint, parameter: random_location, body_opts: {"new_name": exist_location['name'] })
    expect(response.status).to eq(400)
    expect(response.body).to include('Not Deleted')
    expect(response.reason_phrase).to eq('Bad Request')
  end

  it "verifies delete #{endpoint} location name and new_name are same returns status code 500" do
    response = api_client.company_request(endpoint: endpoint, parameter: employee["id_#{id_of}_id"])
    name_for_delete = JSON.parse(response.body)['name']
    deleted_record = api_client.company_request(endpoint: endpoint, type_request: :delete, parameter: name_for_delete, body_opts: { "new_name": name_for_delete} )
    expect(deleted_record.status).to eq(400)
  end
end