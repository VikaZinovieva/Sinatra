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

get '/locations/:id' do
  DBController.find_location_by({ id: params['id'] })
end

get '/locations/:name' do
  DBController.find_location_by({ name: params['name'] })
end

get '/projects/:id' do
  DBController.find_project_by({ id: params['id'] })
end

get '/projects/:name' do
  DBController.find_project_by({ name: params['name'] })
end

get '/employees/:id' do
  DBController.find_employee_by({ id: params['id'] })
end

get '/employees/:name' do
  DBController.find_employee_by({ name: params['name'] })
end

get '/employees/:surname' do
  DBController.find_employee_by({ surname: params['surname'] })
end

post '/locations' do
  begin
    DBController.create_location(params[:location])

  rescue StandardError => e
    puts "StandardError #{e.message}"
  end
end

post '/employees' do
  begin
    DBController.create_employee(params[:employee])
    status 201
  rescue StandardError => e
    puts "StandardError #{e.message}"
  end
end

post '/projects' do
  begin
    DBController.create_project(params[:project])
    status 201
  rescue StandardError => e
    puts "StandardError #{e.message}"
  end
end

patch '/locations/:name' do
  begin
    DBController.edit_location({ name: params['name'] }, { name: params['new_name'] })
    status 200
  rescue StandardError => e
    puts "StandardError #{e.message}"
  end
end

patch '/projects/:name' do
  begin
    DBController.edit_project({ name: params['name'] }, { name: params['new_name'] })
    status 200
  rescue StandardError => e
    puts "StandardError #{e.message}"
  end
end

patch '/employees/:name' do
  begin
    DBController.edit_employee({ name: params['name'] }, { name: params['new_name'] })
    status 200
  rescue StandardError => e
    puts "StandardError #{e.message}"
  end
end

patch '/employees/:surname' do
  begin
    DBController.edit_employee({ surname: params['surname'] }, { surname: params['new_surname'] })
    status 200
  rescue StandardError => e
    puts "StandardError #{e.message}"
  end
end

patch '/employees/:email' do
  begin
    DBController.edit_employee({ email: params['email'] }, { name: params['new_email'] })
    status 200
  rescue StandardError => e
    puts "StandardError #{e.message}"
  end
end

delete '/employees/:surname' do
  begin
    DBController.delete_employee({ surname: params['surname'] })
    status 200
  rescue NoMethodError => e
    puts "NoMethodError #{e.message}"
  end
end

delete '/projects/:name' do
  begin
    DBController.delete_project({ name: params['name'] }, { name: params['new_name'] })
    status 200
  rescue NoMethodError => e
    puts "NoMethodError #{e.message}"
  end
end

delete '/locations/:name' do
  begin
    DBController.delete_location({ name: params['name'] }, { name: params['new_name'] })
    status 200
  rescue NoMethodError => e
    puts "NoMethodError #{e.message}"
  end
end
