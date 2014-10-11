require 'spec_helper'

describe Rundeck::Client do
  # `run_job` is an alias of `execute_job`.
  %w('execute_job', 'run_job').each do |method_name|
    describe ".#{method_name}" do
      context 'with all required options',
              vcr: { cassette_name: 'run_job_valid' } do
        before do
          options = {
            query: {
              argString:
                '-repository ci -release SNAPSHOT -packages app-SNAPSHOT'
            }
          }
          @run_job = Rundeck.run_job('2', options)
        end
        subject { @run_job }

        it { is_expected.to be_a Rundeck::ObjectifiedHash }
        it { is_expected.to respond_to(:user) }
        it { is_expected.to respond_to(:date_started) }
        its(:job) { is_expected.to respond_to(:name) }
        its(:job) { is_expected.to respond_to(:group) }
        its(:job) { is_expected.to respond_to(:project) }
        its(:job) { is_expected.to respond_to(:description) }

        it 'expects a post to have been made' do
          expect(
              a_post('/job/2/executions?argString=-repository%20ci%20-release%20SNAPSHOT%20-packages%20app-SNAPSHOT')
          ).to have_been_made
        end
      end

      context 'without required options',
              vcr: { cassette_name: 'run_job_invalid' } do
        specify do
          expect do
            Rundeck.run_job('2')
          end.to raise_error(Rundeck::Error::BadRequest,
                             /Job options were not valid:/)
        end
      end
    end
  end

  # The anvils demo doesn't have any executions by default.
  # Login and run the 'nightly_catalog_rebuild' job a few times.
  describe '.job_executions', vcr: { cassette_name: 'job_executions' } do
    before do
      @job_executions = Rundeck.job_executions('1')
    end
    subject { @job_executions }

    it { is_expected.to be_an Array }

    it 'expects a get to have been made' do
      expect(a_get('/job/1/executions')).to have_been_made
    end
  end

  describe '.running_job_executions' do
    before do
      @running_jobs = Rundeck.running_job_executions('anvils')
    end
    subject { @running_jobs }

    context 'when there are multiple executions', vcr: { cassette_name: 'running_jobs_multiple' } do
      it { is_expected.to be_an Array }
      its('first') { is_expected.to respond_to(:user) }
      its('first') { is_expected.to respond_to(:date_started) }
      its('first') { is_expected.to respond_to(:job) }
    end

    context 'when there is a single execution', vcr: { cassette_name: 'running_jobs_single' } do
      it { is_expected.to be_a Rundeck::ObjectifiedHash }
      it { is_expected.to respond_to(:user) }
      it { is_expected.to respond_to(:date_started) }
      it { is_expected.to respond_to(:job) }
    end

    context 'when there are no running executions',
            vcr: { cassette_name: 'running_jobs_none' } do
      it { is_expected.to be_nil }
    end

    it 'expects a get to have been made' do
      expect(a_get('/executions/running?project=anvils')).to have_been_made
    end
  end

  describe '.delete_job_executions' do
    before do
      @job_executions = Rundeck.delete_job_executions('1')
    end
    subject { @job_executions }

    context 'when a job has executions',
            vcr: { cassette_name: 'delete_job_executions' } do

      it { is_expected.to respond_to(:successful) }
      it { is_expected.to respond_to(:requestcount) }

      it 'expects a delete to have been made' do
        expect(a_delete('/job/1/executions')).to have_been_made
      end
    end

    context 'when a job does not have executions',
            vcr: { cassette_name: 'delete_job_executions_invalid' } do
      it { is_expected.to respond_to(:successful) }
      its('successful.count') { is_expected.to eq('0') }
      its(:allsuccessful) { is_expected.to eq('true') }
    end
  end
end
