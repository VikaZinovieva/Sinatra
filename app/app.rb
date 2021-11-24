require "sinatra/activerecord"

set :database, {:adapter =>'sqlite3', :database=>'company.db'}

class MyCompany < Sinatra::Base
  register Sinatra::ActiveRecordExtension
end