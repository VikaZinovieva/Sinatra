require_relative '../spec_helper'
require 'securerandom'

RSpec.describe 'DELETE/projects' do
  let(:api_client) { ApiClient.new }
  let(:all_records) { JSON.parse(ApiClient.new.company_request(endpoint: 'projects').body) }
  let(:random_record) { JSON.parse(ApiClient.new.company_request(endpoint: 'projects').body).sample }
  let(:employee) { JSON.parse(ApiClient.new.company_request(endpoint: 'employees').body).sample }

  it_behaves_like 'non-authorized user'
  it_behaves_like 'invalid delete request', 'projects'
  it_behaves_like 'valid delete request', 'projects'
end
