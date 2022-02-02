require_relative '../spec_helper'
require 'securerandom'

RSpec.describe 'GET/projects' do
  let(:api_client) { ApiClient.new }
  let(:all_records) { JSON.parse(ApiClient.new.company_request(endpoint: 'projects').body) }

  it_behaves_like 'non-authorized user'
  it_behaves_like 'valid get request', 'projects', 'id'
  it_behaves_like 'valid get request', 'projects', 'name'
  it_behaves_like 'invalid get request', 'projects'
  it_behaves_like 'invalid get request', 'projects'
end


