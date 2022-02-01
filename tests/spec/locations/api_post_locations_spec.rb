require_relative '../spec_helper'
require 'securerandom'

RSpec.describe 'POST/locations' do
  let(:api_client) { ApiClient.new }

  it_behaves_like 'non-authorized user'
  it_behaves_like 'valid post request', 'locations'
  it_behaves_like 'invalid post request', 'locations'
end
