require 'spec_helper'

describe Rundeck::Client do
  describe '.system_info', vcr: { cassette_name: 'system_info' } do
    before do
      @system_info = Rundeck.system_info
    end

    it 'expects a get to have been made' do
      expect(a_get('/system/info')).to have_been_made
    end

    it '@system_info reponse is expected to be a Objectified Hash' do
      expect(@system_info).to be_a Rundeck::ObjectifiedHash
    end

    describe '#system_info system block response validation' do

      it 'rundeck block response' do
        expect(@system_info.system.rundeck.version).to eq("2.4.2")
        expect(@system_info.system.rundeck.build).to eq("2.4.2-1")
        expect(@system_info.system.rundeck.node).to eq("rundeck-test")
        expect(@system_info.system.rundeck.base).to eq("/var/lib/rundeck")
        expect(@system_info.system.rundeck.apiversion).to eq("12")
      end

      it 'os block response' do
        expect(@system_info.system.os.arch).to eq("amd64")
        expect(@system_info.system.os.name).to eq("Linux")
        expect(@system_info.system.os.version).to eq("2.6.32-431.17.1.el6.x86_64")
      end

      it 'jvm block response' do
        expect(@system_info.system.jvm.name).to eq("Java HotSpot(TM) 64-Bit Server VM")
        expect(@system_info.system.jvm.vendor).to eq("Oracle Corporation")
        expect(@system_info.system.jvm.version).to eq("1.7.0_76")
        expect(@system_info.system.jvm.implementationversion).to eq("24.76-b04")
      end

      describe '#system_info stats block response validation' do

        it 'uptime block response' do
          expect(@system_info.system.stats.uptime.since.datetime).to eq("2015-03-31T09:37:34Z")
        end

        it 'cpu block response' do
          expect(@system_info.system.stats.cpu.loadaverage.__content__).to eq("0.0")
          expect(@system_info.system.stats.cpu.processors).to eq("2")
        end

        it 'memory block response' do
          expect(@system_info.system.stats.memory.max).to eq("954728448")
          expect(@system_info.system.stats.memory.free).to eq("187146352")
          expect(@system_info.system.stats.memory.total).to eq("498073600")
        end

        it 'scheduler block response' do
          expect(@system_info.system.stats.scheduler.running).to eq("0")
        end

        it 'threads block response' do
          expect(@system_info.system.stats.threads.active).to eq("26")
        end

      end
    end

  end
end
