require 'rspec'
require 'pry'
require 'json'
require 'faraday'
require_relative 'api_client'
require 'rake'
require 'securerandom'
require_relative 'non_authorized_user_shared_examples'
require_relative 'invalid_request_shared_examples'
require_relative 'valid_request_shared_examples'
require_relative '../support/rspec_formatter'
require_relative './employees/employee_helper/employee_helper'
