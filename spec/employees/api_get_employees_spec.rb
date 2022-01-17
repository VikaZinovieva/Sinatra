require_relative '../spec_helper'
require 'securerandom'

RSpec.shared_examples 'invalid get request' do |find_by|
  random_employee = JSON.parse(ApiClient.new.company_request(endpoint: 'employees').body).sample

  before(:each) { ApiClient.new.company_request(endpoint: 'employees', type_request: :delete, parameter: random_employee['name']) }

  [{ test_type: "non-exist #{find_by}", find_by: SecureRandom.alphanumeric(15) },
   { test_type: "empty #{find_by}", find_by: '' },
   { test_type: 'deleted employee', find_by: random_employee['name'] }
  ].each do |data|
    it "verifies with #{data[:test_type]} returns status code 404" do
      response = api_client.company_request(endpoint: 'employees', body_opts: { find_by: data[:find_by] })
      expect(response.status).to eq(404)
    end
  end

end
RSpec.describe 'GET/employees' do
  let(:api_client) { ApiClient.new }
  employees = JSON.parse(ApiClient.new.company_request(endpoint: 'employees').body)
  employee_keys = 'id' && 'name' && 'surname' && 'position' && 'email' && 'id_location_id' && 'id_project_id'

  context 'when valid  request' do
    it 'verifies response include all keys of employees' do
      expect(employees.each { |elem| elem.has_key?(employee_keys) }).to be_truthy
      response = api_client.company_request(endpoint: 'employees')
      expect(response.status).to eq(200)
    end

    it 'verifies return employee by surname' do
      employee = employees.sample
      employee_surname = employee['surname']
      response = api_client.company_request(endpoint: 'employees', body_opts: { "surname": employee_surname })
      find_employee = JSON.parse(response.body)
      expect(find_employee['surname']).to eq(employee['surname'])
      expect(find_employee['name']).to eq(employee['name'])
      expect(find_employee['email']).to eq(employee['email'])
      expect(response.status).to eq(200)
    end

    it 'verifies return employee by name' do
      employee = employees.sample
      employee_name = employee['name']
      response = api_client.company_request(endpoint: 'employees', body_opts: { "name": employee_name })
      find_employee = JSON.parse(response.body)
      expect(find_employee['name']).to eq(employee['name'])
      expect(find_employee['surname']).to eq(employee['surname'])
      expect(find_employee['email']).to eq(employee['email'])
      expect(response.status).to eq(200)
    end

    it 'verifies return employee by id' do
      employee = employees.sample
      employee_id = employee['id']
      response = api_client.company_request(endpoint: 'employees', body_opts: { "id": employee_id })
      find_employee = JSON.parse(response.body)
      expect(find_employee['id']).to eq(employee['id'])
      expect(find_employee['name']).to eq(employee['name'])
      expect(find_employee['email']).to eq(employee['email'])
      expect(response.status).to eq(200)
    end
  end

  it_behaves_like 'invalid get request', 'name', 'surname'
  it_behaves_like 'non-authorized user'
end
