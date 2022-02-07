require_relative '../spec_helper'
require 'securerandom'

RSpec.shared_examples 'invalid get request for employee' do |find_by|
  random_employee = JSON.parse(ApiClient.new.company_request(endpoint: 'employees').body).sample

  before(:all) { ApiClient.new.company_request(endpoint: 'employees', type_request: :delete, parameter: random_employee['email']) }

  [{ test_type: "non-exist #{find_by}", find_by: SecureRandom.alphanumeric(15) },
   { test_type: "empty #{find_by}", find_by: '' },
   { test_type: 'deleted employee', find_by: random_employee['email'] }
  ].each do |data|
    it "verifies with #{data[:test_type]} returns status code 404" do
      response = api_client.company_request(endpoint: 'employees', body_opts: { "#{find_by}": data[:find_by] })
      expect(response.status).to eq(404)
    end
  end
end

RSpec.describe 'GET/employees' do
  let(:api_client) { ApiClient.new }
  employees = JSON.parse(ApiClient.new.company_request(endpoint: 'employees').body)
  employee_keys = %w(id name surname email position id_location_id id_project_id)

  before(:all) { EmployeeHelper.new.post_employee }

  context 'when valid request for employee' do
    it 'verifies response include all keys of employees' do
      employees.each { |record| expect(record.keys).to eq(employee_keys) }
    end

      it 'verifies return employee by email' do
        employee = employees.sample
        response = api_client.company_request(endpoint: 'employees', body_opts: { email: employee['email'] })
        find_employee = JSON.parse(response.body)
        expect(find_employee['surname']).to eq(employee['surname'])
        expect(find_employee['name']).to eq(employee['name'])
        expect(find_employee['email']).to eq(employee['email'])
        expect(response.status).to eq(200)
    end
  end

  it_behaves_like 'invalid get request for employee', 'surname'
  it_behaves_like 'invalid get request for employee', 'name'
  it_behaves_like 'invalid get request for employee', 'email'
  it_behaves_like 'non-authorized user'
end
