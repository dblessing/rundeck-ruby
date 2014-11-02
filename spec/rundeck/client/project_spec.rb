require 'spec_helper'

describe Rundeck::Client do
  describe '.projects', vcr: { cassette_name: 'projects' } do
    before do
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

  describe '.project' do
    context 'when the project exists',
            vcr: { cassette_name: 'project_valid' } do
      before do
        @project = Rundeck.project('anvils')
      end
      subject { @project }

      it { is_expected.to be_a Rundeck::ObjectifiedHash }
      its(:name) { is_expected.to eq('anvils') }
    end

    context 'when the project does not exist',
            vcr: { cassette_name: 'project_invalid' } do
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
            vcr: { cassette_name: 'delete_project_valid' } do
      before do
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
            vcr: { cassette_name: 'delete_project_invalid' } do
      specify do
        expect do
          Rundeck.delete_project('project1')
        end.to raise_error(Rundeck::Error::NotFound,
                           /Project does not exist/)
      end
    end
  end
end
