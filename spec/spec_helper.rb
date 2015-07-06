require 'rspec'
require 'rspec/its'
require 'webmock/rspec'
require 'vcr'
require 'codeclimate-test-reporter'

# Must be called before code is included/required!
CodeClimate::TestReporter.start

require 'support/helpers'
require 'support/shared_examples'

require File.expand_path('../../lib/rundeck', __FILE__)

RSpec.configure do |config|
  config.include Helpers

  config.before(:each) do
    Rundeck.endpoint = 'http://192.168.50.2:4440'
    Rundeck.api_token =
      ENV['TEST_RUNDECK_API_TOKEN'] ||= 'OPIfQ6MOnevhlFThG1af4GAcbPdAgh0B'
    WebMock.reset!
  end
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes/#{Rundeck.api_version}"
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
  config.configure_rspec_metadata!
end

WebMock.allow_net_connect!
# WebMock.disable_net_connect!(allow: 'codeclimate.com')
