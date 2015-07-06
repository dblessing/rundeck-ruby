require 'spec_helper'

describe Rundeck::Client do
  describe '.system_info', vcr: { cassette_name: 'system_info' } do
    before do
      @system_info = Rundeck.system_info
    end
    subject { @system_info }

    it 'expects a get to have been made' do
      expect(a_get('/system/info')).to have_been_made
    end

    it { is_expected.to be_a Rundeck::ObjectifiedHash }

    describe '.rundeck' do
      subject { @system_info.rundeck }

      its(:base) { is_expected.to eq('/var/lib/rundeck') }
    end

    describe '.os' do
      subject { @system_info.os }

      its(:arch) { is_expected.to eq('amd64') }
      its(:name) { is_expected.to eq('Linux') }
    end

    describe '.stats' do
      subject { @system_info.stats }

      its('cpu.processors') { is_expected.to eq('2') }
    end
  end
end
