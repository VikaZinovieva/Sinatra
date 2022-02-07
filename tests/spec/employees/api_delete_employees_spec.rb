require_relative '../spec_helper'
require 'securerandom'

RSpec.describe 'DELETE/employees' do
  let(:api_client) { ApiClient.new }
  let(:employees) { JSON.parse(ApiClient.new.company_request(endpoint: 'employees').body) }

  before(:all) { EmployeeHelper.new.post_employee }

  context 'when authorized user' do
    it 'verifies with deleted employee returns status code 200' do
      random_employee = employees.sample
      employee_for_delete = random_employee['email']
      delete_response = api_client.company_request(endpoint: 'employees', type_request: :delete, parameter: employee_for_delete)
      get_response = api_client.company_request(endpoint: 'employees', body_opts: { 'email': 'employee_for_delete' })
      expect(get_response.body).to include('Employee Not Found')
      expect(get_response.status).to eq(404)
      expect(delete_response.status).to eq(200)
    end
  end

  context 'when invalid request for employee' do
    it 'verifies deleting with non-exist email returns status code 400' do
      random_email = SecureRandom.alphanumeric(7)
      response = api_client.company_request(endpoint: 'employees', type_request: :delete, parameter: random_email)
      employees_after_delete = ApiClient.new.company_request(endpoint: 'employees')
      expect(employees.count).to eq(JSON.parse(employees_after_delete.body).count)
      expect(response.status).to eq(200)
    end
  end

  it_behaves_like 'non-authorized user'
end
