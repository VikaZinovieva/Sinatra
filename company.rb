require 'sinatra'
require_relative 'models'
require 'sinatra/activerecord'

set :database, { adapter: 'sqlite3', database: 'development.sqlite3' }

get '/locations' do
  Locations.all.to_json
end

get '/projects' do
  Projects.all.to_json
end

get '/employees' do
  Employees.all.to_json
end

get '/locations/:id' do |id|
  location = Locations.find(id)
  location.attributes.to_json
end

get '/employees/:id' do |id|
  employee = Employees.find(id)
  employee.attributes.to_json
end

get '/projects/:id' do |id|
  project = Projects.find(id)
  project.attributes.to_json
end

get '/projects/:name' do |name|
  project = Projects.find(name)
  project.attributes.to_json
end

get '/locations/:name' do |name|
  location = Locations.find(name)
  location.attributes.to_json
end

get '/employees/:name' do |name|
  employee = Employees.find(name)
  employee.attributes.to_json
end

post '/locations' do
  location = Locations.create(params[:location])
  status 201
end

post '/employees' do
  employee = Employees.create(params[:employee])
  status 201
end

post '/projects' do
  project = Projects.create(params[:project])
  status 201
end

patch '/locations/:name' do
  location = Locations.find_by(name: params['name'])
  location.update(name: params['name_new'])
  status 200
end

patch '/employees/:name' do
  employee = Employees.find_by(name: params['name'])
  employee.update(name: params['name_new'])
  status 200
end

patch '/employees/:surname' do
  employee = Employees.find_by(surname: params['surname'])
  employee.update(surname: params['surname_new'])
  status 200
end

patch '/employees/:email' do
  employee = Employees.find_by(email: params['email'])
  employee.update(name: params['email_new'])
  status 200
end

delete '/locations/:name' do
  location = Locations.where(name: params['name'])
  location.destroy_all
  status 200
end

delete '/employees/:surname' do
  employee = Employees.where(surname: params['surname'])
  employee.destroy_all
  status 200
end

delete '/projects/:name' do
  begin
    project = Projects.find_by(name: params['name'])
    project_new = Projects.find_by(name: params['name_new'])
    employeess = Employees.where(id_project_id: project['id'])
  rescue NoMethodError => e
    puts "NoMethodError #{e.message}"
  end
  employeess.update_all(id_project_id: project_new['id'])
  project = Projects.where(name: params['name'])
  project.destroy_all
end

delete '/locations/:name' do
  begin
    location = Locationss.find_by(name: params['name'])
    location_new = Locations.find_by(name: params['name_new'])
    employeess = Employees.where(id_location_id: location['id'])
  rescue NoMethodError => e
    puts "NoMethodError #{e.message}"
    employeess.update_all(id_location_id: location_new['id'])
    location = Locations.where(name: params['name'])
    location.destroy_all
  end
end

