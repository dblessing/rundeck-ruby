require 'spec_helper'

describe Rundeck::Client do
  describe '.projects', vcr: { cassette_name: 'project/projects' } do
    before do
      prepare { Rundeck.create_project(project_anvils, 'json') }
      @projects = Rundeck.projects
    end
    subject { @projects }

    its(:project) { is_expected.to be_a Rundeck::ObjectifiedHash }

    describe '#project' do
      subject { @projects.project }

      its(:name) { is_expected.to eq('anvils') }
    end

    it 'expects a get to have been made' do
      expect(a_get('/projects')).to have_been_made
    end
  end

  describe '.create_project' do
    context 'when project does not yet exist' do
      before do
        @project = Rundeck.create_project(content, format)
      end
      subject { @project }

      context 'create with json format',
              vcr: { cassette_name: 'project/create_json' } do
        let(:content) { project_json }
        let(:format) { 'json' }

        it { is_expected.to be_a Rundeck::ObjectifiedHash }
        its(:name) { is_expected.to eq('json_project') }

        it 'expects a post to have been made' do
          expect(a_post('/projects')).to have_been_made
        end
      end

      context 'create with xml format',
              vcr: { cassette_name: 'project/create_xml' } do
        let(:content) { project_xml }
        let(:format) { 'xml' }

        it { is_expected.to be_a Rundeck::ObjectifiedHash }
        its(:name) { is_expected.to eq('xml_project') }

        it 'expects a post to have been made' do
          expect(a_post('/projects')).to have_been_made
        end
      end
    end

    context 'when project already exists',
            vcr: { cassette_name: 'project/create_error' } do
      specify do
        expect do
          Rundeck.create_project(project_anvils, 'json')
        end.to raise_error(Rundeck::Error::Conflict,
                           /project already exists/)
      end
    end
  end

  describe '.project' do
    context 'when the project exists',
            vcr: { cassette_name: 'project/project' } do
      before do
        @project = Rundeck.project('anvils')
      end
      subject { @project }

      it { is_expected.to be_a Rundeck::ObjectifiedHash }
      its(:name) { is_expected.to eq('anvils') }
    end

    context 'when the project does not exist',
            vcr: { cassette_name: 'project/project_error' } do
      specify do
        expect do
          Rundeck.project('nonexistent')
        end.to raise_error(Rundeck::Error::NotFound,
                           /project does not exist/)
      end
    end
  end

  describe '.delete_project' do
    context 'when a project exists',
            vcr: { cassette_name: 'project/delete' } do
      before do
        prepare { Rundeck.create_project(project_deleteme) }
        @project = Rundeck.delete_project(project)
      end

      let(:project) { 'anvils' }
      subject { @project }

      it { is_expected.to be_nil }

      it 'expects a delete to have been made' do
        expect(a_delete('/project/anvils')).to have_been_made
      end
    end

    context 'when a project does not exist',
            vcr: { cassette_name: 'project/delete_error' } do
      specify do
        expect do
          Rundeck.delete_project('nonexistent')
        end.to raise_error(Rundeck::Error::NotFound,
                           /Project does not exist/)
      end
    end
  end

  describe '.configure_project' do
    context 'when a project exists',
            vcr: { cassette_name: 'project/configure' } do
      before do
        prepare { Rundeck.create_project(project_anvils) }
        @project = Rundeck.configure_project(project, project_configure)
      end

      let(:project) { 'anvils' }
      subject { @project }

      it { is_expected.to be_a(Rundeck::ObjectifiedHash) }

      it 'expects a put to have been made' do
        expect(a_put('/project/anvils/config')).to have_been_made
      end
    end

    context 'when a project does not exist',
            vcr: { cassette_name: 'project/configure_error' } do
      specify do
        expect do
          Rundeck.configure_project('nonexistent', project_configure)
        end.to raise_error(Rundeck::Error::NotFound,
                           /Project does not exist/)
      end
    end
  end
end
