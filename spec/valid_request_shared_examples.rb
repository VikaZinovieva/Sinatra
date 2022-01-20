require_relative 'spec_helper'

RSpec.shared_examples 'valid get request' do |endpoint, parameter|
  all_keys = %w(id name description)
  it "verifies response include all keys of #{endpoint}" do
    api_client.company_request(endpoint: endpoint)
    all_records.each { |record| expect(record.keys).to eq(all_keys) }
  end

  it "verifies return #{endpoint} by #{parameter}" do
    random_record = all_records.sample
    response = api_client.company_request(endpoint: endpoint, parameter: random_record["#{parameter}"] )
    find_record = JSON.parse(response.body)
    expect(find_record['name']).to eq(random_record['name'])
    expect(find_record['description']).to eq(random_record['description'])
    expect(response.status).to eq(200)
  end
end

RSpec.shared_examples 'valid post request' do |endpoint|
  [{ test_type: 'max length of name and description', name: SecureRandom.alphanumeric(1000), description: SecureRandom.alphanumeric(1000) },
   { test_type: 'max length of name and min length of description', name: SecureRandom.alphanumeric(1000), description: SecureRandom.alphanumeric(5) },
   { test_type: 'min length of name and max length of description', name: SecureRandom.alphanumeric(5), description: SecureRandom.alphanumeric(1000) },
   { test_type: 'min length of name and description', name: SecureRandom.alphanumeric(5), description: SecureRandom.alphanumeric(5) }
  ].each do |data|
    it "verifies with #{data[:test_type]} create new record in database" do
      post_record = api_client.company_request(endpoint: endpoint, type_request: :post, body_opts: { "name": data[:name], "description": data[:description] })
      response = api_client.company_request(endpoint: endpoint, parameter: data[:name])
      expect(post_record.status).to eq(200)
      expect(JSON.parse(response.body)['description']).to eq(data[:description])
    end
  end
end

RSpec.shared_examples 'valid patch request' do |endpoint, parameter| #parameter = name or description
  [{ test_type: "max length of #{parameter}", "#{parameter}": SecureRandom.alphanumeric(1000) },
   { test_type: "min length of #{parameter}", "#{parameter}": SecureRandom.alphanumeric(5) },
   { test_type: "random valid length of #{parameter}", "#{parameter}": SecureRandom.alphanumeric(12) }
  ].each do |data|
    it "verifies with #{data[:test_type]} updated #{endpoint}" do
      record_for_update = random_record['name']
      patch_response = api_client.company_request(type_request: :patch, endpoint: endpoint, parameter: record_for_update, body_opts: { "#{parameter}": data[:"#{parameter}"]  })
      expect(patch_response.reason_phrase).to eq('OK')
      expect(patch_response.status).to eq(200)
      expect(JSON.parse(api_client.company_request(endpoint: endpoint, parameter: random_record['id']).body)["#{parameter}"]).to eq(data[:"#{parameter}"])
    end
  end
end

RSpec.shared_examples 'valid delete request' do |endpoint|
  id_parameter_id = "id_#{endpoint.chomp('s')}_id"

  it "verifies deleted #{endpoint} that used in employee returns status code 200" do
    get_record_for_delete = api_client.company_request(endpoint: endpoint, parameter: employee[id_parameter_id])
    name_for_delete = JSON.parse(get_record_for_delete.body)['name']
    deleted_record = api_client.company_request(type_request: :delete, endpoint: endpoint, parameter: name_for_delete, body_opts: { "new_name": random_record['name'] })
    response = api_client.company_request(endpoint: endpoint, parameter: name_for_delete)
    expect(deleted_record.status).to eq(200)
    expect(response.status).to eq(404)
    expect(response.body).to include('Not Found')
  end

  it "verifies deleting by old name already updated #{endpoint} returns status code 400" do
    name_for_update = random_record['name']
    new_name = SecureRandom.hex(10)
    patch_response = api_client.company_request(type_request: :patch, endpoint: endpoint, parameter: name_for_update, body_opts: { "name": new_name })
    response = api_client.company_request(type_request: :delete, endpoint: endpoint, parameter: name_for_update, body_opts: { "name": new_name })
    expect(api_client.company_request(endpoint: endpoint, parameter: name_for_update).status).to eq(404)
    expect(api_client.company_request(endpoint: endpoint, parameter: new_name).status).to eq(200)
    expect(patch_response.status).to eq(200)
    expect(response.status).to eq(400)
  end

  it "verifies deleted #{endpoint} that don't used in employee returns status code 200" do
    list_employees = JSON.parse(ApiClient.new.company_request(endpoint: 'employees').body)
    free_id = all_records.map{ |elem| elem["id"] } - list_employees.map{ |elem| elem[id_parameter_id ] }
    name_for_delete = JSON.parse(api_client.company_request(endpoint: endpoint, parameter: free_id.sample).body)['name']
    deleted_response = api_client.company_request(endpoint: endpoint, type_request: :delete, parameter: name_for_delete)
    response = api_client.company_request(endpoint: endpoint, parameter: name_for_delete)
    expect(response.status).to eq(404)
    expect(deleted_response.status).to eq(200)
  end
end
