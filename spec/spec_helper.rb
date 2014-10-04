require 'rspec'
require 'rspec/its'
require 'webmock/rspec'
require 'codeclimate-test-reporter'

require 'support/helpers'

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
    WebMock.reset!
  end

  config.alias_it_should_behave_like_to :it_supports, 'with support for'
  config.include Helpers
end


