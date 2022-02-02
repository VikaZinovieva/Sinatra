require_relative '../../spec_helper'
require 'faker'

class EmployeeHelper
  def post_employee
    employees = JSON.parse(ApiClient.new.company_request(endpoint: 'employees').body)
    5.times { ApiClient.new.company_request(type_request: :post, endpoint: 'employees', body_opts: generate_body) } == employees.empty?
  end

  private

  def generate_body
    { "name": Faker::Name.first_name,
      "surname": Faker::Name.last_name,
      "email": Faker::Internet.email,
      "position": Faker::Job.title,
      "id_location_id": JSON.parse(ApiClient.new.company_request(endpoint: 'locations').body).sample['id'],
      "id_project_id": JSON.parse(ApiClient.new.company_request(endpoint: 'projects').body).sample['id']
    }
  end
end
