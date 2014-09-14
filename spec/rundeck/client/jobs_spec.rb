require 'spec_helper'

describe Rundeck::Client do
  describe '.jobs' do
    before do
      stub_get('/project/My_Project/jobs', 'jobs_my_project')
      @jobs = Rundeck.jobs('My_Project')
    end
    subject { @jobs }

    it { is_expected.to be_an Array }
    its('first.name') { is_expected.to eq('Job 1') }

    it 'expects a get to have been made' do
      expect(a_get('/project/My_Project/jobs')).to have_been_made
    end
  end

  describe '.job' do
    before do
      stub_get('/job/c07518ef-b697-4792-9a59-5b4f08855b67', 'job')
      @job = Rundeck.job('c07518ef-b697-4792-9a59-5b4f08855b67')
    end
    subject { @job }

    it { is_expected.to be_a Rundeck::ObjectifiedHash }
    its(:name) { is_expected.to eq('Hello World') }

    it 'expects a get to have been made' do
      expect(
        a_get('/job/c07518ef-b697-4792-9a59-5b4f08855b67')
      ).to have_been_made
    end
  end

  describe '.job_executions' do
    before do
      stub_get('/job/c07518ef-b697-4792-9a59-5b4f08855b67/executions',
               'job_executions')
      @job_executions =
          Rundeck.job_executions('c07518ef-b697-4792-9a59-5b4f08855b67')
    end
    subject { @job_executions }

    it { is_expected.to be_an Array }
    its('first.job.name') { is_expected.to eq('Job 1') }

    it 'expects a get to have been made' do
      expect(
        a_get('/job/c07518ef-b697-4792-9a59-5b4f08855b67/executions')
      ).to have_been_made
    end
  end
end
