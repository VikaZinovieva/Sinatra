require_relative '../spec_helper'
require 'securerandom'
require 'faker'

RSpec.describe 'PATCH/employees' do
  let(:api_client) { ApiClient.new }
  let(:random_employee) { JSON.parse(ApiClient.new.company_request(endpoint: 'employees').body).sample }

  before(:all) { EmployeeHelper.new.post_employee }

  context 'when valid request for employee' do
    %w(name surname position).each do |data|
      it "verifies update employee with #{data} returns status code 200" do
        new_data = Faker::Name.first_name
        patch_response = api_client.company_request(type_request: :patch, endpoint: 'employees', parameter: random_employee['email'], body_opts: { "#{data}": new_data })
        response = api_client.company_request(endpoint: 'employees', body_opts: { "email": random_employee['email'] })
        expect(JSON.parse(response.body)["#{data}"]).to eq(new_data)
        expect(patch_response.reason_phrase).to include('OK')
        expect(patch_response.status).to eq(200)
      end
    end

    %w(location project).each do |data|
      it "verifies update employee with new id of #{data} returns status code 200" do
        all_endpoint = JSON.parse(ApiClient.new.company_request(endpoint: "#{data}s").body)
        all_id = all_endpoint.map { |elem| elem['id'] }
        new_id = all_id.sample
        patch_response = api_client.company_request(type_request: :patch, endpoint: 'employees', parameter: random_employee['email'], body_opts: { "id_#{data}_id": new_id })
        response = api_client.company_request(endpoint: 'employees', body_opts: { "email": random_employee['email'] })
        expect(JSON.parse(response.body)["id_#{data}_id"]).to eq(new_id)
        expect(JSON.parse(response.body)['surname']).to eq(random_employee['surname'])
        expect(JSON.parse(response.body)['name']).to eq(random_employee['name'])
        expect(patch_response.reason_phrase).to include('OK')
        expect(patch_response.status).to eq(200)
      end

      it 'verifies update employee with new email status returns code 200' do
        new_email = Faker::Internet.email
        patch_response = api_client.company_request(type_request: :patch, endpoint: 'employees', parameter: random_employee['email'], body_opts: { "email": new_email })
        responce = api_client.company_request(endpoint: 'employees', parameter: random_employee['email'])
        expect(responce.status).to eq(404)
        expect(patch_response.reason_phrase).to include('OK')
        expect(patch_response.status).to eq(200)
      end

      context 'when invalid request for employee' do
        %w(name surname email).each do |data|
          it "verifies with empty new #{data} don't update employee" do
            api_client.company_request(type_request: :patch, endpoint: 'employees', parameter: random_employee['email'], body_opts: { "#{data}": "" })
            get_after_patch = api_client.company_request(endpoint: 'employees', body_opts: { "email": random_employee['email'] })
            expect(JSON.parse(get_after_patch.body)["#{data}"]).to eq(random_employee["#{data}"])
          end

          it 'verifies updating non-exist employee returns status code 400' do
            response = api_client.company_request(type_request: :patch, endpoint: 'employees', parameter: SecureRandom.alphanumeric(7), body_opts: { "surname": Faker::Name.first_name })
            expect(response.body).to include("Employee' Surname Not Updated")
            expect(response.status).to eq(400)
          end
        end

        it_behaves_like 'non-authorized user'
      end
    end
  end
end
