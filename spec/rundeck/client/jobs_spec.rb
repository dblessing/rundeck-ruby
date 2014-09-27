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

  describe '.delete_job' do
    before do
      stub_delete('/job/c07518ef-b697-4792-9a59-5b4f08855b67', 'empty')
      @job = Rundeck.delete_job('c07518ef-b697-4792-9a59-5b4f08855b67')
    end
    subject { @job }

    it { is_expected.to be_nil }

    it 'expects a delete to have been made' do
      expect(
          a_delete('/job/c07518ef-b697-4792-9a59-5b4f08855b67')
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

  describe '.run_job' do
    before do
      stub_post('/job/c07518ef-b697-4792-9a59-5b4f08855b67/executions',
                'job_run')
      @run_job =
          Rundeck.run_job('c07518ef-b697-4792-9a59-5b4f08855b67')
    end
    subject { @run_job }

    it { is_expected.to be_a Rundeck::ObjectifiedHash }
    its('job.name') { is_expected.to eq('My_Job') }

    it 'expects a post to have been made' do
      expect(
        a_post('/job/c07518ef-b697-4792-9a59-5b4f08855b67/executions')
      ).to have_been_made
    end
  end

  describe '.import_job' do
    context 'with valid format' do
      before do
        stub_post("/jobs/import?format=#{format}", 'jobs_import')
        @import = Rundeck.import_jobs(content, format)
      end
      subject { @import }

      context 'yaml' do
        let(:format) { 'yaml' }
        let(:content) { '- id: 123456' }

        it { is_expected.to be_a Rundeck::ObjectifiedHash }
        its('succeeded.count') { is_expected.to eq('1') }
        its('failed.count') { is_expected.to eq('0') }

        it 'expects a post to have been made' do
          expect(a_post('/jobs/import?format=yaml')).to have_been_made
        end
      end

      context 'xml' do
        let(:format) { 'xml' }
        let(:content) { '<id>12345</id>' }

        it { is_expected.to be_a Rundeck::ObjectifiedHash }
        its('succeeded.count') { is_expected.to eq('1') }
        its('failed.count') { is_expected.to eq('0') }

        it 'expects a post to have been made' do
          expect(a_post('/jobs/import?format=xml')).to have_been_made
        end
      end
    end

    context 'with invalid format' do
      specify do
        expect do
          Rundeck.import_jobs('content', 'invalid_format')
        end.to raise_error(Rundeck::Error::InvalidAttributes,
                           'format must be yaml or xml')
      end
    end
  end

  describe '.export_job' do
    context 'with valid format' do
      before do
        stub_get("/jobs/export?project=my_project&format=#{format}", fixture)
        @jobs = Rundeck.export_jobs('my_project', format)
      end
      subject { @jobs }

      context 'yaml' do
        let(:format) { 'yaml' }
        let(:fixture) { 'jobs_yaml' }

        it { is_expected.to be_a String }
        it { is_expected.to include 'id: c07518ef-b697-4792-9a59-5b4f08855b67' }

        it 'expects a get to have been made' do
          expect(
              a_get('/jobs/export?project=my_project&format=yaml')
          ).to have_been_made
        end
      end

      context 'xml' do
        let(:format) { 'xml' }
        let(:fixture) { 'jobs_xml' }

        it { is_expected.to be_a String }
        it { is_expected.to include '<id>c07518ef-b697-4792-9a59-5b4f08855b67</id>' }

        it 'expects a get to have been made' do
          expect(
              a_get('/jobs/export?project=my_project&format=xml')
          ).to have_been_made
        end
      end
    end

    context 'with invalid format' do
      specify do
        expect do
          Rundeck.export_jobs('my_project', 'invalid_format')
        end.to raise_error(Rundeck::Error::InvalidAttributes,
                           'format must be yaml or xml')
      end
    end
  end
end
