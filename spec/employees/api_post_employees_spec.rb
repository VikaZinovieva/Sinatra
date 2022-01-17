require_relative '../spec_helper'
require 'securerandom'
require 'faker'

RSpec.describe 'POST/employees' do
  let(:api_client) { ApiClient.new }
  employees = JSON.parse(ApiClient.new.company_request(endpoint: 'employees').body).sample
  locations = JSON.parse(ApiClient.new.company_request(endpoint: 'locations').body).sample
  projects = JSON.parse(ApiClient.new.company_request(endpoint: 'projects').body).sample

  context 'when valid  request' do
    random_valid_body = {
      "name": Faker::Name.first_name,
      "surname": Faker::Name.last_name,
      "email": Faker::Internet.email,
      "position": Faker::Job.title,
      "id_location_id": locations['id'],
      "id_project_id": projects['id']
    }

    it 'verifies create employee' do
      new_employee = api_client.company_request(type_request: :post, endpoint: 'employees', body_opts: random_valid_body)
      response = api_client.company_request(endpoint: 'employees', body_opts: { "surname": random_valid_body[:surname] })
      posted_employee = JSON.parse(response.body)
      expect(new_employee.status).to eq(200)
      expect(posted_employee['email']).to eq(random_valid_body[:email])
      employees
    end
  end

  context 'when invalid  request' do
    [{ test_type: 'all credentials are presented except email', name: Faker::Name.first_name, surname: Faker::Name.last_name, position: Faker::Job.title, id_location_id: locations['id'], id_project_id: projects['id'] },
     { test_type: 'all credentials are presented except name', surname: Faker::Name.last_name, position: Faker::Job.title, email: Faker::Internet.email, id_location_id: locations['id'], id_project_id: projects['id'] },
     { test_type: 'all credentials are presented except surname', name: Faker::Name.first_name, position: Faker::Job.title, email: Faker::Internet.email, id_location_id: locations['id'], id_project_id: projects['id'] },
     { test_type: 'all credentials are presented, invalid id_location_id and id_project_id', name: Faker::Name.first_name, surname: Faker::Name.last_name, position: Faker::Job.title, email: Faker::Internet.email, id_location_id: Random.new.rand(2..22), id_project_id: Random.new.rand(1..17) }
    ].each do |data|
      it "verifies with #{data[:test_type]} record wasn't created in database" do
        all_employees_before_post = JSON.parse(api_client.company_request(endpoint: 'employees').body)
        api_client.company_request(type_request: :post, endpoint: 'employees', body_opts: { "name": data[:name], "surname": data[:surname], "position": data[:position], "email": data[:email], "id_location_id": data[:id_location_id], "id_project_id": data[:id_project_id] })
        all_locations_after_post = JSON.parse(api_client.company_request(endpoint: 'employees').body)
        expect(all_employees_before_post.count).to eq(all_locations_after_post.count)
      end
    end
  end

  it_behaves_like 'non-authorized user'
end
