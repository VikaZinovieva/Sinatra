require_relative '../spec_helper'
require 'securerandom'

RSpec.describe 'GET/locations' do
  let(:api_client) { ApiClient.new }
  let(:all_records) { JSON.parse(ApiClient.new.company_request(endpoint: 'locations').body) }

  it_behaves_like 'non-authorized user'
  it_behaves_like 'valid get request', 'locations'
  it_behaves_like 'invalid get request', 'locations'
end
