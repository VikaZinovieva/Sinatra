require 'sinatra/activerecord'

class Locations < ActiveRecord::Base
  validates :name, :description, presence: true
  validates :name, uniqueness: true
  validates :name, :description, length: { in: 5...1000, message: 'invalid length!'}
end

class Employees < ActiveRecord::Base
  validates :name, :surname, :email, :position, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, message: 'invalid email format!' }
end

class Projects < ActiveRecord::Base
  validates :name, :description, presence: true
  validates :name, uniqueness: true
  validates :name, :description, length: { in: 5...1000, message: 'invalid length!'}
end
