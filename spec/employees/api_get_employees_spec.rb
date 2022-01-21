require_relative '../spec_helper'
require 'securerandom'

RSpec.shared_examples 'invalid get request' do |find_by|
  random_employee = JSON.parse(ApiClient.new.company_request(endpoint: 'employees').body).sample

  before(:all) { ApiClient.new.company_request(endpoint: 'employees', type_request: :delete, parameter: random_employee['surname']) }

  [{ test_type: "non-exist #{find_by}", find_by: SecureRandom.alphanumeric(15) },
   { test_type: "empty #{find_by}", find_by: '' },
   { test_type: 'deleted employee', find_by: random_employee['surname'] }
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

  context 'when valid  request' do
    it 'verifies response include all keys of employees' do
      employees.each { |record| expect(record.keys).to eq(employee_keys) }
    end

    %w(name surname email).each do |data|
      it "verifies return employee by #{data}" do
        employee = employees.sample
        response = api_client.company_request(endpoint: 'employees', body_opts: { data => employee[data] })
        find_employee = JSON.parse(response.body)
        expect(find_employee['surname']).to eq(employee['surname'])
        expect(find_employee['name']).to eq(employee['name'])
        expect(find_employee['email']).to eq(employee['email'])
        expect(response.status).to eq(200)
      end
    end
  end

  it_behaves_like 'invalid get request', 'surname'
  it_behaves_like 'invalid get request', 'name'
  it_behaves_like 'non-authorized user'
end
