require 'sinatra'
require_relative 'models'
require 'sinatra/activerecord'

set :database, { adapter: 'sqlite3', database: 'development.sqlite3' }


get '/locations' do
  # return Locations.all.map{ |l| l.to_json}
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


post '/locations' do
  location = Locations.create(params[:location])
  location.to_json
end


post '/employees' do
  employee = Employees.create(params[:employee])
  employee.to_json
end

post '/projects' do
  project = Projects.create(params[:project])
  project.to_json
end

patch '/locations/:name' do
  location = Locations.find_by(name: params['name'])
  location.update(name: params['name_new'])
end


delete'/locations/:name' do
location = Locations.where(name: params['name'])
location.destroy_all
end
