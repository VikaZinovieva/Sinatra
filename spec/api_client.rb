require_relative 'spec_helper' #??
require 'faraday' #??
require 'json' #??

class ApiClient
  def initialize
    @base_url = 'http://localhost:4567/'
  end

  def get_locations
    app_request(:get, '/locations', [username, password] == %w(superadmin 12345))
  end

  def get_projects

  end

  def get_employees

  end
end
