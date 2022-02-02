require_relative '../spec_helper'
require 'securerandom'

RSpec.describe 'PATCH/locations' do
  let(:api_client) { ApiClient.new }
  let(:random_record) { JSON.parse(ApiClient.new.company_request(endpoint: 'locations').body).sample }

  it_behaves_like 'invalid patch request', 'locations', 'name'
  it_behaves_like 'valid patch request', 'locations', 'name'
  it_behaves_like 'invalid patch request', 'locations', 'description'
  it_behaves_like 'valid patch request', 'locations', 'description'
  it_behaves_like 'non-authorized user'
end
