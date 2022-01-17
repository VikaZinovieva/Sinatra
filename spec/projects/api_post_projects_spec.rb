require_relative '../spec_helper'
require 'securerandom'

RSpec.describe 'POST/projects' do
  let(:api_client) { ApiClient.new }

  it_behaves_like 'non-authorized user'
  it_behaves_like 'invalid post request', 'projects'
  it_behaves_like 'valid post request', 'projects'
end
