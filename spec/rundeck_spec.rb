require 'spec_helper'

describe Rundeck do
  after { Rundeck.reset }

  # nothing too special to check, just existence
  it { is_expected.to respond_to(:endpoint) }
  it { is_expected.to respond_to(:endpoint=) }
  it { is_expected.to respond_to(:api_token) }
  it { is_expected.to respond_to(:api_token=) }

  describe '.client' do
    subject { Rundeck.client }
    it { is_expected.to be_a Rundeck::Client }
  end

  describe '.user_agent=' do
    subject { Rundeck.user_agent }

    context 'when unspecified' do
      it { is_expected.to eq(Rundeck::Configuration::DEFAULT_USER_AGENT) }
    end

    context 'when specified' do
      before { Rundeck.user_agent = 'Custom Rundeck Ruby Gem' }
      it { is_expected.to eq('Custom Rundeck Ruby Gem') }
    end
  end

  # This seems silly, but since we're adding special logic to
  # `method_missing` we should check it still raises an error in
  # the proper case
  describe '.method_missing' do
    context 'when client does not respond' do
      it { expect { Rundeck.fake }.to raise_error NoMethodError }
    end
  end

  describe '.configure' do
    Rundeck::Configuration::VALID_OPTIONS_KEYS.each do |key|
      context "when setting #{key}" do
        subject { Rundeck.send(key) }

        before do
          Rundeck.configure do |config|
            config.send("#{key}=", key)
          end
          @key = key == :endpoint ? "#{key}/api/#{Rundeck.api_version}" : key
        end

        it { is_expected.to eq(@key) }
      end
    end
  end
end
