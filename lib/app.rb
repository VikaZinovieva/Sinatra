require 'sinatra/activerecord'
require 'sinatra'
require_relative 'models'

set :database, { adapter: 'sqlite3', database: '../db/base/development.sqlite3' }