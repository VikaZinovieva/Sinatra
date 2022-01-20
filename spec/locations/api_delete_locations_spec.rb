require_relative '../spec_helper'
require 'securerandom'

RSpec.describe 'DELETE/locations' do
  let(:api_client) { ApiClient.new }
  let(:all_records) { JSON.parse(ApiClient.new.company_request(endpoint: 'locations').body) }
  let(:employee) { JSON.parse(ApiClient.new.company_request(endpoint: 'employees').body).sample }
  let(:random_record) { JSON.parse(ApiClient.new.company_request(endpoint: 'locations').body).sample }

  it_behaves_like 'non-authorized user'
  it_behaves_like 'valid delete request', 'locations'
  it_behaves_like 'invalid delete request', 'locations'
end
