require 'spec_helper'

describe Rundeck::Client do
  describe '.jobs', vcr: { cassette_name: 'jobs' } do
    before do
      @jobs = Rundeck.jobs('anvils')
    end
    subject { @jobs }

    it { is_expected.to be_an Array }
    its(:length) { is_expected.to eq(6) }

    # Only tests the first element, but it's just a sanity check
    its('first') { is_expected.to respond_to(:name) }
    its('first') { is_expected.to respond_to(:group) }
    its('first') { is_expected.to respond_to(:project) }
    its('first') { is_expected.to respond_to(:description) }

    it 'expects a get to have been made' do
      expect(a_get('/project/anvils/jobs')).to have_been_made
    end
  end

  describe '.job', vcr: { cassette_name: 'job' }  do
    before do
      @job = Rundeck.job('2')
    end
    subject { @job }

    it { is_expected.to be_a Rundeck::ObjectifiedHash }
    it { is_expected.to respond_to(:id) }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:loglevel) }
    it { is_expected.to respond_to(:sequence) }
    its(:sequence) { is_expected.to respond_to(:command) }

    it 'expects a get to have been made' do
      expect(a_get('/job/2')).to have_been_made
    end
  end

  describe '.delete_job' do
    context 'when a job exists',
            vcr: { cassette_name: 'delete_job_valid' } do
      before do
        @job = Rundeck.delete_job(job_id)
      end
      let(:job_id) { '3' }
      subject { @job }

      it { is_expected.to be_nil }

      it 'expects a delete to have been made' do
        expect(a_delete('/job/3')).to have_been_made
      end
    end

    context 'when a job does not exist',
            vcr: { cassette_name: 'delete_job_invalid' } do
      specify do
        expect do
          Rundeck.delete_job('123456')
        end.to raise_error(Rundeck::Error::NotFound,
                           /Job ID does not exist: 123456/)
      end
    end
  end

  describe '.import_job' do
    context 'with valid format' do
      before do
        @import = Rundeck.import_jobs(content, format)
      end
      subject { @import }

      context 'yaml', vcr: { cassette_name: 'import_job_yaml' } do
        let(:format) { 'yaml' }
        let(:content) { job_yaml }

        it { is_expected.to be_a Rundeck::ObjectifiedHash }
        its('succeeded.count') { is_expected.to eq('1') }
        its('failed.count') { is_expected.to eq('0') }

        its('succeeded') { is_expected.to respond_to(:job) }
        its('succeeded.job') { is_expected.to respond_to(:id) }
        its('succeeded.job') { is_expected.to respond_to(:name) }
        its('succeeded.job') { is_expected.to respond_to(:group) }
        its('succeeded.job') { is_expected.to respond_to(:project) }
        its('succeeded.job') { is_expected.to respond_to(:url) }

        it 'expects a post to have been made' do
          expect(a_post('/jobs/import?format=yaml')).to have_been_made
        end
      end

      context 'xml', vcr: { cassette_name: 'import_job_xml' } do
        let(:format) { 'xml' }
        let(:content) { job_xml }

        it { is_expected.to be_a Rundeck::ObjectifiedHash }
        its('succeeded.count') { is_expected.to eq('1') }
        its('failed.count') { is_expected.to eq('0') }

        its('succeeded') { is_expected.to respond_to(:job) }
        its('succeeded.job') { is_expected.to respond_to(:id) }
        its('succeeded.job') { is_expected.to respond_to(:name) }
        its('succeeded.job') { is_expected.to respond_to(:group) }
        its('succeeded.job') { is_expected.to respond_to(:project) }
        its('succeeded.job') { is_expected.to respond_to(:url) }

        it 'expects a post to have been made' do
          expect(a_post('/jobs/import?format=xml')).to have_been_made
        end
      end
    end

    context 'with invalid format', vcr: { cassette_name: 'import_job_invalid' } do
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
        @jobs = Rundeck.export_jobs('anvils', format)
      end
      subject { @jobs }

      context 'yaml', vcr: { cassette_name: 'export_job_yaml' } do
        let(:format) { 'yaml' }

        it { is_expected.to be_a String }
        it { is_expected.to include 'project: anvils' }
        it { is_expected.to include 'loglevel: INFO' }
        it { is_expected.to include 'sequence:' }

        it 'expects a get to have been made' do
          expect(
              a_get('/jobs/export?project=anvils&format=yaml')
          ).to have_been_made
        end
      end

      context 'xml', vcr: { cassette_name: 'export_job_xml' } do
        let(:format) { 'xml' }

        it { is_expected.to be_a String }
        it { is_expected.to include '<project>anvils</project>' }
        it { is_expected.to include '<loglevel>INFO</loglevel>' }
        it { is_expected.to include '<sequence' }

        it 'expects a get to have been made' do
          expect(
              a_get('/jobs/export?project=anvils&format=xml')
          ).to have_been_made
        end
      end
    end

    context 'with invalid format', vcr: { cassette_name: 'export_job_invalid' } do
      specify do
        expect do
          Rundeck.export_jobs('anvils', 'invalid_format')
        end.to raise_error(Rundeck::Error::InvalidAttributes,
                           'format must be yaml or xml')
      end
    end
  end
end
