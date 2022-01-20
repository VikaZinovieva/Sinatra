require_relative 'spec_helper'

RSpec.shared_examples 'non-authorized user' do
  [{ test_type: 'username and invalid password', username: ApiClient::DEFAULT_USERNAME, password: SecureRandom.hex },
   { test_type: 'invalid username and password', username: SecureRandom.hex, password: SecureRandom.hex },
   { test_type: 'swapped username and password', username: ApiClient::DEFAULT_PASSWORD, password: ApiClient::DEFAULT_USERNAME },
   { test_type: 'username and invalid password', username: SecureRandom.hex, password: ApiClient::DEFAULT_PASSWORD }
  ].each do |data|
    it "verifies #{data[:test_type]} response status code is 401" do
      response = api_client.company_request(auth_opts: { username: data[:username], password: data[:password] })
      expect(response.status).to eq(401)
    end
  end
end
