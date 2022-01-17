require 'sinatra'
require_relative '../models/models'
require 'sinatra/activerecord'
require_relative '../tools/db_controller'

set :database, { adapter: 'sqlite3', database: '../db/base/development.sqlite3' }

use Rack::Auth::Basic, 'Restricted' do |username, password|
  [username, password] == %w(superadmin 12345)
end

get '/locations' do
  DBController.locations
end

get '/projects' do
  DBController.projects
end

get '/employees' do
  DBController.employees
end

get '/locations/:name' do
  begin
    DBController.find_location_by({ name: params['name'] })
  rescue StandardError => e
    body "Location Not Found #{e.message}"
    status 404
  end
end

get '/projects/:name' do
  begin
    DBController.find_project_by({ name: params['name'] })
  rescue StandardError => e
    body "Project Not Found #{e.message}"
    status 404
  end
end

get '/employees/:name' do
  begin
    DBController.find_employee_by({ name: params['name'] })
  rescue StandardError => e
    body "Employee Not Found #{e.message}"
    status 404
  end
end

get '/employees/:surname' do
  begin
    DBController.find_employee_by({ surname: params['surname'] })
  rescue StandardError => e
    body "Employee Not Found #{e.message}"
    status 404
  end
end

post '/locations' do
  begin
    request = Rack::Request.new env
    body = JSON.parse(request.body.read)
    DBController.create_location({ name: body['name'], description: body['description'] })
  rescue StandardError => e
    body "Location Not Created #{e.message}"
    status 400
  end
end

post '/employees' do
  begin
    request = Rack::Request.new env
    body = JSON.parse(request.body.read)
    DBController.create_employee({ name: body['name'], surname: body['surname'], email: body['email'], position: body['position'] })
    status 201
  rescue StandardError => e
    body "Employee Not Created #{e.message}"
    status 400
  end
end

post '/projects' do
  begin
    request = Rack::Request.new env
    body = JSON.parse(request.body.read)
    DBController.create_project({ name: body['name'], description: body['description'] })
    status 201
  rescue StandardError => e
    body "Project Not Created #{e.message}"
    status 400
  end
end

patch '/locations/:name' do
  begin
    request = Rack::Request.new env
    body = JSON.parse(request.body.read)
    DBController.edit_location({ name: params['name'] }, { name: body['new_name'] }) # description: body['new_description']
    status 200
  rescue StandardError => e
    body "Location Not Updated #{e.message}"
    status 400
  end
end

patch '/projects/:name' do
  begin
    request = Rack::Request.new env
    body = JSON.parse(request.body.read)
    DBController.edit_project({ name: params['name'] }, { name: body['new_name'] })
    status 200
  rescue StandardError => e
    body "Project Not Updated #{e.message}"
    status 400
  end
end

patch '/employees/:name' do
  begin
    request = Rack::Request.new env
    body = JSON.parse(request.body.read)
    DBController.edit_employee({ name: params['name'] }, { name: body['new_name'] })
    status 200
  rescue StandardError => e
    body "Employee' Name Not Updated #{e.message}"
    status 400
  end
end

patch '/employees/:surname' do
  begin
    request = Rack::Request.new env
    body = JSON.parse(request.body.read)
    DBController.edit_employee({ surname: params['surname'] }, { surname: body['new_surname'] })
    status 200
  rescue StandardError => e
    body "Employee' Surname Not Updated #{e.message}"
    status 400
  end
end

patch '/employees/:email' do
  begin
    request = Rack::Request.new env
    body = JSON.parse(request.body.read)
    DBController.edit_employee({ email: params['email'] }, { email: body['new_email'] })
    status 200
  rescue StandardError => e
    body "Employee' Email Not Updated #{e.message}"
    status 400
  end
end

delete '/employees/:surname' do
  begin
    DBController.delete_employee({ surname: params['surname'] })
    status 200
  rescue NoMethodError => e
    body "Employee Not Deleted #{e.message}"
    status 400
  end
end

delete '/projects/:name' do
  begin
    request = Rack::Request.new env
    body = JSON.parse(request.body.read)
    DBController.delete_project({ name: params['name'] }, { name: body['new_name'] })
    status 200
  rescue NoMethodError => e
    body "Project Not Deleted #{e.message}"
    status 400
  end
end

delete '/locations/:name' do
  begin
    request = Rack::Request.new env
    body = JSON.parse(request.body.read)
    DBController.delete_location({ name: params['name'] }, { name: body['new_name'] })
    status 200
  rescue NoMethodError => e
    body "Location Not Deleted #{e.message}"
    status 400
  end
end
