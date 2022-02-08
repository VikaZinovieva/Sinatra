require 'faraday'
require 'json'
require_relative 'spec_helper'

class ApiClient
  APP_JS = 'application/json'
  DEFAULT_USERNAME = 'superadmin'
  DEFAULT_PASSWORD = '12345'

  def initialize
    @base_url = 'http://localhost:4567/'
  end

  def company_request(type_request: :get, parameter: nil, body_opts: nil, endpoint: nil, auth_opts: { username: DEFAULT_USERNAME, password: DEFAULT_PASSWORD })
    url = parameter == nil ? "#{@base_url}#{endpoint}" : "#{@base_url}#{endpoint}/#{parameter}"
    app_request(type_request, url, body_opts, auth_opts)
  end

  private

  def app_request(type, url, body, auth_opts)
    connection = Faraday.new(@base_url)
    connection.request(:basic_auth,  auth_opts[:username], auth_opts[:password])
    connection.send(type, url) do |req|
      req.headers['Content-Type'] = APP_JS
      req.body = body.to_json unless body.nil?
    end
  end
end
