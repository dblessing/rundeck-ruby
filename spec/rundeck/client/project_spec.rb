require 'spec_helper'

describe Rundeck::Client do
  describe '.projects', vcr: { cassette_name: 'projects' } do
    before do
      @projects = Rundeck.projects
    end
    subject { @projects }

    its(:project) { is_expected.to be_an Array }

    it 'expects a get to have been made' do
      expect(a_get('/projects')).to have_been_made
    end
  end
end
