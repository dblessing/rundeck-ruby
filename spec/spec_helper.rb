require 'rspec'
require 'rspec/its'
require 'webmock/rspec'
require 'vcr'
require 'codeclimate-test-reporter'

# Must be called before code is included/required!
CodeClimate::TestReporter.start

require 'support/helpers'

require File.expand_path('../../lib/rundeck', __FILE__)

WebMock.disable_net_connect!(allow: 'codeclimate.com')

RSpec.configure do |config|
  config.include Helpers

  config.before(:each) do
    # Configuration for Anvils Demo Vagrant Box. API token might change.
    Rundeck.endpoint = 'http://192.168.50.2:4440'
    Rundeck.api_token = 'i8iMfXUOpYzVJ9SAkh7pRQMTZI1Bnsyu'
    WebMock.reset!
  end
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes/#{Rundeck.api_version}"
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
  config.configure_rspec_metadata!
end
