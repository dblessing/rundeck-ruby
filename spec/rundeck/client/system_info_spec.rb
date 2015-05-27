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
      it 'should return the Rundeck version' do
        expect(@system_info.system.rundeck.version).to eq('2.4.2')
      end

      it 'should return the Build number' do
        expect(@system_info.system.rundeck.build).to eq('2.4.2-1')
      end

      it 'should return the Node name' do
        expect(@system_info.system.rundeck.node).to eq('rundeck-test')
      end

      it 'should return the Base path where rundeck is installed' do
        expect(@system_info.system.rundeck.base).to eq('/var/lib/rundeck')
      end

      it 'should return the API version' do
        expect(@system_info.system.rundeck.apiversion).to eq('12')
      end

      it 'should return the OS architecture' do
        expect(@system_info.system.os.arch).to eq('amd64')
      end

      it 'should return the OS name' do
        expect(@system_info.system.os.name).to eq('Linux')
      end

      it 'should return the OS version (kernel version)' do
        expect(@system_info.system.os.version).to eq('2.6.32-431.17.1.el6.x86_64')
      end

      it 'should return the JVM name' do
        expect(@system_info.system.jvm.name).to eq('Java HotSpot(TM) 64-Bit Server VM')
      end

      it 'should return the JVM vendor' do
        expect(@system_info.system.jvm.vendor).to eq('Oracle Corporation')
      end

      it 'should return the JVM version' do
        expect(@system_info.system.jvm.version).to eq('1.7.0_76')
      end

      it 'should return the JVM implementation ersion' do
        expect(@system_info.system.jvm.implementationversion).to eq('24.76-b04')
      end

      describe '#system_info stats block response validation' do
        it 'should return the Uptime stats since date and time' do
          expect(@system_info.system.stats.uptime.since.datetime).to eq('2015-03-31T09:37:34Z')
        end

        it 'should return the CPU load average stats' do
          expect(@system_info.system.stats.cpu.loadaverage.__content__).to eq('0.0')
        end

        it 'should return the CPU processor count' do
          expect(@system_info.system.stats.cpu.processors).to eq('2')
        end

        it 'should return the maximum memory' do
          expect(@system_info.system.stats.memory.max).to eq('954728448')
        end

        it 'should return the free memory' do
          expect(@system_info.system.stats.memory.free).to eq('187146352')
        end

        it 'should return the total memory' do
          expect(@system_info.system.stats.memory.total).to eq('498073600')
        end

        it 'should return the running jobs count in scheduler' do
          expect(@system_info.system.stats.scheduler.running).to eq('0')
        end

        it 'tshould return the current active threads count' do
          expect(@system_info.system.stats.threads.active).to eq('26')
        end
      end
    end
  end
end
