require 'spec_helper'

describe Rundeck::Client do
  describe '.jobs', vcr: { cassette_name: 'job/jobs' } do
    before do
      prepare do
        Rundeck.create_project(project_anvils, 'json')
        Rundeck.import_jobs(job_yaml, 'yaml')
        Rundeck.import_jobs(job_xml, 'xml')
      end
      @jobs = Rundeck.jobs('anvils')
    end
    subject { @jobs }

    it { is_expected.to be_a Rundeck::ObjectifiedHash }

    describe '#job' do
      subject { @jobs.job }

      it { is_expected.to be_an Array }
      its(:length) { is_expected.to eq(2) }

      context 'the first job' do
        subject { @jobs.job[0] }

        it_behaves_like 'a job'
        its(:project) { is_expected.to eq('anvils') }
      end
    end

    it 'expects a get to have been made' do
      expect(a_get('/project/anvils/jobs')).to have_been_made
    end
  end

  describe '.job',
           vcr: { cassette_name: 'job/job',
                  match_requests_on: [:method] } do
    before do
      VCR.use_cassette('job/jobs') do
        @job_id = Rundeck.jobs('anvils').job.first.id
      end
      @job = Rundeck.job(@job_id)
    end
    subject { @job }

    it_behaves_like 'a job'
    its(:loglevel) { is_expected.to eq('INFO') }

    describe '#context' do
      subject { @job.context }

      its(:project) { is_expected.to eq('anvils') }
    end

    describe '#sequence' do
      subject { @job.sequence }

      it { is_expected.to respond_to(:keepgoing) }
      it { is_expected.to respond_to(:strategy) }
      it { is_expected.to respond_to(:command) }
    end

    it 'expects a get to have been made' do
      expect(a_get("/job/#{@job_id}")).to have_been_made
    end
  end

  describe '.delete_job' do
    context 'when a job exists',
            vcr: { cassette_name: 'job/delete_valid',
                   match_requests_on: [:method] } do
      before do
        VCR.use_cassette('job/jobs') do
          @job_id = Rundeck.jobs('anvils').job.first.id
        end
        @job = Rundeck.delete_job(@job_id)
      end
      let(:job_id) { '3' }
      subject { @job }

      it { is_expected.to be_nil }

      it 'expects a delete to have been made' do
        expect(a_delete("/job/#{@job_id}")).to have_been_made
      end
    end

    context 'when a job does not exist',
            vcr: { cassette_name: 'job/delete_invalid' } do
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
        prepare do
          VCR.use_cassette('job/jobs') do
            jobs = Rundeck.jobs('anvils').job
            jobs.each { |job| Rundeck.delete_job(job.id) }
          end
        end
        @job_import = Rundeck.import_jobs(content, format)
      end
      subject { @job_import }

      context 'yaml', vcr: { cassette_name: 'import_job_yaml' } do
        let(:format) { 'yaml' }
        let(:content) { job_yaml }

        it { is_expected.to be_a Rundeck::ObjectifiedHash }
        its('failed.count') { is_expected.to eq('0') }

        describe '#succeeded' do
          subject { @job_import.succeeded }

          its(:count) { is_expected.to eq('1') }

          describe '#job' do
            subject { @job_import.succeeded.job }

            it_behaves_like 'a job import'
          end
        end

        it 'expects a post to have been made' do
          expect(a_post('/jobs/import?format=yaml')).to have_been_made
        end
      end

      context 'xml', vcr: { cassette_name: 'import_job_xml' } do
        let(:format) { 'xml' }
        let(:content) { job_xml }

        it { is_expected.to be_a Rundeck::ObjectifiedHash }
        its('failed.count') { is_expected.to eq('0') }

        describe '#succeeded' do
          subject { @job_import.succeeded }
          its(:count) { is_expected.to eq('1') }

          describe '#job' do
            subject { @job_import.succeeded.job }

            it_behaves_like 'a job import'
          end
        end

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

  describe '.export_jobs' do
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
