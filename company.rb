require 'sinatra'

get '/' do
  "Hello World"
end


get '/:id' do
  "Article #{params[:id]}"
end

get '/*/edit' do
  "Edit #{params[:splat].first}"
end