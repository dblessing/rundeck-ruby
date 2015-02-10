require 'spec_helper'

describe Rundeck::Client do
  describe '.execute_job' do
    context 'with all required options',
            vcr: { cassette_name: 'run_job_valid' } do
      before do
        options = {
          query: {
            argString:
              '-repository ci -release SNAPSHOT -packages app-SNAPSHOT'
          }
        }
        @job = Rundeck.run_job('2', options)
      end
      subject { @job }

      its(:count) { is_expected.to eq('1') }

      describe '#execution' do
        subject { @job.execution }

        it_behaves_like 'an execution'

        describe '#job' do
          subject { @job.execution.job }

          it_behaves_like 'a job with a project attribute'
        end
      end

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

  # Alias of execute job
  describe '.run_job' do
    subject { Rundeck }

    it { is_expected.to respond_to(:run_job) }
  end

  # The anvils demo doesn't have any executions by default.
  # Login and run the 'nightly_catalog_rebuild' job a few times.
  describe '.job_executions', vcr: { cassette_name: 'job_executions' } do
    before do
      @job_executions = Rundeck.job_executions('1')
    end
    subject { @job_executions }

    it { is_expected.to be_a Rundeck::ObjectifiedHash }

    describe '#execution' do
      subject { @job_executions.execution }

      it { is_expected.to be_an Array }

      context '#first' do
        subject { @job_executions.execution[0] }

        it_behaves_like 'a past execution'

        describe '#job' do
          subject { @job_executions.execution[0].job }

          it_behaves_like 'a job with a project attribute'
        end
      end
    end

    it 'expects a get to have been made' do
      expect(a_get('/job/1/executions')).to have_been_made
    end
  end

  describe '.running_job_executions' do
    before do
      @running_jobs = Rundeck.running_job_executions('anvils')
    end
    subject { @running_jobs }

    context 'when there are multiple executions',
            vcr: { cassette_name: 'running_jobs_multiple' } do
      it { is_expected.to be_a Rundeck::ObjectifiedHash }

      describe '#execution' do
        subject { @running_jobs.execution }

        it { is_expected.to be_an Array }

        context 'the first execution' do
          subject { @running_jobs.execution[0] }

          it_behaves_like 'an execution'
        end
      end

      it 'expects a get to have been made' do
        expect(a_get('/executions/running?project=anvils')).to have_been_made
      end
    end

    context 'when there is a single execution',
            vcr: { cassette_name: 'running_jobs_single' } do
      it { is_expected.to be_a Rundeck::ObjectifiedHash }

      describe '#execution' do
        subject { @running_jobs.execution }

        it_behaves_like 'an execution'
      end

      it 'expects a get to have been made' do
        expect(a_get('/executions/running?project=anvils')).to have_been_made
      end
    end

    context 'when there are no running executions',
            vcr: { cassette_name: 'running_jobs_none' } do
      it { is_expected.to be_a Rundeck::ObjectifiedHash }
      its(:count) { is_expected.to eq('0') }

      it 'expects a get to have been made' do
        expect(a_get('/executions/running?project=anvils')).to have_been_made
      end
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
      it { is_expected.to respond_to(:allsuccessful) }
      it { is_expected.to respond_to(:requestcount) }

      it 'expects a delete to have been made' do
        expect(a_delete('/job/1/executions')).to have_been_made
      end
    end

    context 'when a job does not have executions',
            vcr: { cassette_name: 'delete_job_executions_invalid' } do
      its(:allsuccessful) { is_expected.to eq('true') }
      its(:requestcount) { is_expected.to eq('0') }

      describe '#successful' do
        subject { @job_executions.successful }

        its(:count) { is_expected.to eq('0') }
      end
    end
  end

  describe '.delete_execution' do
    context 'when an execution exists',
            vcr: { cassette_name: 'delete_execution_valid' } do
      before do
        @execution = Rundeck.delete_execution('1')
      end
      subject { @execution }

      it { is_expected.to be_nil }
      it 'expects a delete to have been made' do
        expect(a_delete('/execution/1')).to have_been_made
      end
    end

    context 'when an execution does not exist',
            vcr: { cassette_name: 'delete_execution_invalid' } do
      specify do
        expect do
          Rundeck.delete_execution('123456')
        end.to raise_error(Rundeck::Error::NotFound,
                           /Execution ID does not exist: 123456/)
      end
    end
  end

  describe '.abort_execution' do
    context 'with a valid execution id' do
      before do
        @execution = Rundeck.abort_execution(id)
      end
      subject { @execution }

      context 'when the execution is running',
              vcr: { cassette_name: 'abort_execution_valid' } do
        let(:id) { '5' }

        it { is_expected.to be_a Rundeck::ObjectifiedHash }
        its(:status) { is_expected.to eq('aborted') }

        describe '#execution' do
          subject { @execution.execution }

          it { is_expected.to respond_to(:id) }
        end

        it 'expects a post to have been made' do
          expect(a_post('/execution/5/abort')).to have_been_made
        end
      end

      context 'when the execution is not running',
              vcr: { cassette_name: 'abort_execution_not_running' } do
        let(:id) { '4' }

        it { is_expected.to be_a Rundeck::ObjectifiedHash }
        its(:status) { is_expected.to eq('failed') }
        its(:reason) { is_expected.to eq('Job is not running') }

        describe '#execution' do
          subject { @execution.execution }

          it { is_expected.to respond_to(:id) }
        end
      end
    end

    context 'when the execution does not exist',
            vcr: { cassette_name: 'abort_executions_invalid' } do
      specify do
        expect do
          Rundeck.abort_execution('123456')
        end.to raise_error(Rundeck::Error::NotFound,
                           /Execution ID does not exist: 123456/)
      end
    end
  end

  describe '.execution' do
    context 'with a valid execution id',
            vcr: { cassette_name: 'execution_valid' } do
      before do
        @execution = Rundeck.execution('15')
      end
      subject { @execution }

      it_behaves_like 'a past execution'

      describe '#job' do
        subject { @execution.job }

        it_behaves_like 'a job with a project attribute'
      end

      it 'expects a get to have been made' do
        expect(a_get('/execution/15')).to have_been_made
      end
    end

    context 'with an invalid id',
            vcr: { cassette_name: 'execution_invalid' } do
      specify do
        expect do
          Rundeck.execution('2')
        end.to raise_error(Rundeck::Error::NotFound,
                           /Execution ID does not exist:/)
      end
    end
  end

  describe '.bulk_delete_executions' do
    context 'with the correct parameters' do
      before do
        @executions = Rundeck.bulk_delete_executions(ids)
      end
      subject { @executions }

      context 'with valid executions',
              vcr: { cassette_name: 'bulk_delete_executions_valid' } do
        let(:ids) { %w(3 4 5) }

        its(:requestcount) { is_expected.to eq('3') }
        its(:allsuccessful) { is_expected.to eq('true') }

        describe '#successful' do
          subject { @executions.successful }

          it { is_expected.to respond_to(:count) }
        end

        it 'expects a post to have been made' do
          expect(a_post('/executions/delete?ids=3,4,5')).to have_been_made
        end
      end

      context 'with invalid executions',
              vcr: { cassette_name: 'bulk_delete_executions_invalid' } do
        let(:ids) { %w(1000 2000 3000) }

        its(:requestcount) { is_expected.to eq('3') }
        its('successful.count') { is_expected.to eq('0') }
        its('failed.count') { is_expected.to eq('3') }
      end
    end

    context 'with a non-array id' do
      specify do
        expect do
          Rundeck.bulk_delete_executions('123')
        end.to raise_error(Rundeck::Error::InvalidAttributes,
                           '`ids` must be an array of ids')
      end
    end
  end

  describe '.execution_state' do
    context 'with a valid execution id',
            vcr: { cassette_name: 'execution_state_valid' } do
      before do
        @state = Rundeck.execution_state('6')
      end
      subject { @state }

      it { is_expected.to respond_to(:starttime) }
      it { is_expected.to respond_to(:updatetime) }
      it { is_expected.to respond_to(:steps) }
      its(:executionid) { is_expected.to eq('6') }
      its(:executionstate) { is_expected.to eq('SUCCEEDED') }

      it 'expects a get to have been made' do
        expect(a_get('/execution/6/state')).to have_been_made
      end
    end

    context 'with an invalid execution id',
            vcr: { cassette_name: 'execution_state_invalid' } do
      specify do
        expect do
          Rundeck.execution_state('123456')
        end.to raise_error(Rundeck::Error::NotFound)
      end
    end
  end

  describe '.execution_query' do
    before do
      @executions = Rundeck.execution_query(project, query: query)
    end
    subject { @executions }

    context 'with a valid project id' do
      let(:project) { 'anvils' }

      context 'without any query parameters',
              vcr: { cassette_name: 'execution_query_no_params_valid' } do
        let(:query) { {} }

        it { is_expected.to respond_to(:execution) }

        describe '#count' do
          subject { @executions.count.to_i }

          it { is_expected.to be > 0 }
        end

        describe '#execution' do
          subject { @executions.execution }

          it { is_expected.to be_an Array }

          context 'the first execution' do
            subject { @executions.execution[0] }

            it_behaves_like 'an execution'

            describe '#job' do
              subject { @executions.execution[0].job }

              it_behaves_like 'a job with a project attribute'
            end
          end
        end

        it 'expects a get to have been made' do
          expect(a_get('/executions?project=anvils')).to have_been_made
        end
      end

      # context 'with query parameters',
      #         vcr: { cassette_name: 'execution_query_params_valid' } do
      #   let(:query) {  }
      #
      #   it 'expects a get to have been made' do
      #     expect(a_get('/executions')).to have_been_made
      #   end
      # end
    end

    context 'with an invalid project id',
            vcr: { cassette_name: 'execution_query_invalid' } do
      let(:project) { 'other_project' }
      let(:query) { {} }

      its(:count) { is_expected.to eq('0') }

      it 'expects a get to have been made' do
        expect(a_get('/executions?project=other_project')).to have_been_made
      end
    end
  end

  # describe '.execution_output' do
  #
  # end

  # describe '.execution_output_with_state' do
  #
  # end
end
