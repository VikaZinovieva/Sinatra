require 'faraday'
require 'json'
require_relative '../spec_helper'


class ApiClient
  APP_JS = 'application/json'
  DEFAULT_USERNAME = 'superadmin'
  DEFAULT_PASSWORD = '12345'

  def initialize
    @base_url = 'http://localhost:4567/'
  end

  def locations(type_request: :get, parameter: nil, body_opts: nil, username: DEFAULT_USERNAME, password: DEFAULT_PASSWORD)
    url = parameter == nil ? "#{@base_url}locations" : "#{@base_url}locations/#{parameter}"
    app_request(type_request, url, body_opts, username, password)
  end

  private

  def app_request(type, url, body, username, password)
    connection = Faraday.new(@base_url)
    connection.request(:basic_auth, username, password)
    connection.send(type, url) do |req|
      req.headers['Content-Type'] = APP_JS
      req.body = body.to_json unless body.nil?
    end
  end
end
