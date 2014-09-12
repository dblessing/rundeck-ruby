require 'spec_helper'

describe Rundeck::Request do
  it { is_expected.to respond_to(:get) }
  it { is_expected.to respond_to(:post) }
  it { is_expected.to respond_to(:put) }
  it { is_expected.to respond_to(:delete) }

  describe '.default_options' do
    subject { Rundeck::Request.default_options }
    it { is_expected.to be_a Hash }
    its([:format]) { is_expected.to eq(:xml) }
    its([:headers]) { is_expected.to eq('Accept' => 'application/json') }
    its([:default_params]) { is_expected.to be_nil }
  end

  describe '#set_request_defaults' do
    context 'when endpoint' do
      context 'is not set' do
        it do
          expect do
            Rundeck::Request.new.set_request_defaults(nil, 'secret')
          end.to raise_error(Rundeck::Error::MissingCredentials,
                             'Please set an endpoint to API')
        end
      end

      context 'is set' do
        before do
          @rundeck_request = Rundeck::Request.new
          @rundeck_request
              .set_request_defaults('http://api.example.org', 'secret')
        end
        subject { @rundeck_request }

        it { expect(Rundeck::Request.base_uri).to eq('http://api.example.org') }
        its(:api_token) { is_expected.to eq('secret') }
      end
    end
  end
end
