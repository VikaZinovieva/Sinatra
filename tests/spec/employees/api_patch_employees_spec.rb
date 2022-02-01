require_relative '../spec_helper'
require 'securerandom'
require 'faker'

RSpec.describe 'PATCH/employees' do
  let(:api_client) { ApiClient.new }
  let(:random_employee) { JSON.parse(ApiClient.new.company_request(endpoint: 'employees').body).sample }

  before(:all) { EmployeeHelper.new.post_employee }

  context 'when valid request for employee' do
    it 'verifies update employee returns status code 200' do
      update_surname = Faker::Name.first_name
      patch_response = api_client.company_request(type_request: :patch, endpoint: 'employees', parameter: random_employee['surname'], body_opts: { "surname": update_surname })
      response = api_client.company_request(endpoint: 'employees', body_opts: { "surname": update_surname })
      expect(JSON.parse(response.body)['surname']).to eq(update_surname)
      expect(patch_response.reason_phrase).to include('OK')
      expect(patch_response.status).to eq(200)
    end
  end

  context 'when invalid request for employee' do
    %w(name surname email).each do |data|
      it "verifies with empty new #{data} don't update employee" do
        api_client.company_request(type_request: :patch, endpoint: 'employees', parameter: random_employee['surname'], body_opts: { "#{data}": "" })
        get_after_patch = api_client.company_request(endpoint: 'employees', body_opts: { "surname": random_employee['surname'] })
        expect(JSON.parse(get_after_patch.body)["#{data}"]).to eq(random_employee["#{data}"])
      end

      it 'verifies updating non-exist employee returns status code 400' do
        response = api_client.company_request(type_request: :patch, endpoint: 'employees', parameter: Faker::Name.first_name, body_opts: { "surname": Faker::Name.first_name })
        expect(response.body).to include("Employee' Surname Not Updated")
        expect(response.status).to eq(400)
      end
    end
    it_behaves_like 'non-authorized user'
  end
end
