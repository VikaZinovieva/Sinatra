require_relative '../spec_helper'
require 'securerandom'

RSpec.describe 'DELETE/employees' do
  let(:api_client) { ApiClient.new }
  let(:employees) { JSON.parse(ApiClient.new.company_request(endpoint: 'employees').body) }

  context 'when authorized user' do
    it 'verifies with deleted employee returns status code 200' do
      random_employee = employees.sample
      surname_for_delete = random_employee['surname']
      delete_response = api_client.company_request(endpoint: 'employees', type_request: :delete, parameter: surname_for_delete)
      get_response = api_client.company_request(endpoint: 'employees', body_opts: { 'surname': 'surname_for_delete'} )
      expect(get_response.body).to include('Employee Not Found')
      expect(get_response.status).to eq(404)
      expect(delete_response.status).to eq(200)
    end
  end

  context 'when invalid request' do
    it 'verifies deleting with non-exist surname returns status code 400' do
      random_surname = SecureRandom.alphanumeric(7)
      response = api_client.company_request(endpoint: 'employees', type_request: :delete, parameter: random_surname)
      employees_after_delete = ApiClient.new.company_request(endpoint: 'employees')
      expect(employees.count).to eq(JSON.parse(employees_after_delete.body).count)
      expect(response.status).to eq(200)
    end
  end
  it_behaves_like 'non-authorized user'
end
