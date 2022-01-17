require_relative '../spec_helper'
require 'securerandom'

RSpec.describe 'PATCH/locations' do
  let(:api_client) { ApiClient.new }
  let(:random_name) { JSON.parse(ApiClient.new.company_request(endpoint: 'projects').body).sample }

  it_behaves_like 'invalid patch request', 'projects'
  it_behaves_like 'valid patch request', 'projects'
  it_behaves_like 'non-authorized user'
end
