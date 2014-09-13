require 'rspec'
require 'rspec/its'
require 'webmock/rspec'
require 'codeclimate-test-reporter'

CodeClimate::TestReporter.start

WebMock.disable_net_connect!(allow: 'codeclimate.com')

require File.expand_path('../../lib/rundeck', __FILE__)

def load_fixture(name)
  File.new(File.dirname(__FILE__) + "/fixtures/#{name}.xml")
end

RSpec.configure do |config|
  config.before(:each) do
    Rundeck.endpoint = 'https://api.example.com'
    Rundeck.api_token = 'secret'
  end
end

# GET
def stub_get(path, fixture, accept = 'xml')
  stub_request(:get, "#{Rundeck.endpoint}#{path}")
      .with(headers: { 'Accept' => "application/#{accept}",
                       'X-Rundeck-Auth-Token' => Rundeck.api_token })
      .to_return(body: load_fixture(fixture))
end

def a_get(path, accept = 'xml')
  a_request(:get, "#{Rundeck.endpoint}#{path}")
      .with(headers: { 'Accept' => "application/#{accept}",
                       'X-Rundeck-Auth-Token' => Rundeck.api_token })
end

# POST
def stub_post(path, fixture, status_code = 200, accept = 'xml')
  stub_request(:post, "#{Rundeck.endpoint}#{path}")
      .with(headers: { 'Accept' => "application/#{accept}",
                       'X-Rundeck-Auth-Token' => Rundeck.api_token })
      .to_return(body: load_fixture(fixture), status: status_code)
end

def a_post(path, accept = 'xml')
  a_request(:post, "#{Rundeck.endpoint}#{path}")
      .with(headers: { 'Accept' => "application/#{accept}",
                       'X-Rundeck-Auth-Token' => Rundeck.api_token })
end

# PUT
def stub_put(path, fixture, accept = 'xml')
  stub_request(:put, "#{Rundeck.endpoint}#{path}")
      .with(headers: { 'Accept' => "application/#{accept}",
                       'X-Rundeck-Auth-Token' => Rundeck.api_token })
      .to_return(body: load_fixture(fixture))
end

def a_put(path, accept = 'xml')
  a_request(:put, "#{Rundeck.endpoint}#{path}")
      .with(headers: { 'Accept' => "application/#{accept}",
                       'X-Rundeck-Auth-Token' => Rundeck.api_token })
end

# DELETE
def stub_delete(path, fixture, accept = 'xml')
  stub_request(:delete, "#{Rundeck.endpoint}#{path}")
      .with(headers: { 'Accept' => "application/#{accept}",
                       'X-Rundeck-Auth-Token' => Rundeck.api_token })
      .to_return(body: load_fixture(fixture))
end

def a_delete(path, accept = 'xml')
  a_request(:delete, "#{Rundeck.endpoint}#{path}")
      .with(headers: { 'Accept' => "application/#{accept}",
                       'X-Rundeck-Auth-Token' => Rundeck.api_token })
end
