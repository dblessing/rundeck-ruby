require 'spec_helper'

describe Rundeck::Client do
  describe '.jobs' do
    before do
      stub_get('/project/My_Project/jobs', 'jobs_my_project')
      @jobs = Rundeck.jobs('My_Project')
    end
    subject { @jobs }

    it { is_expected.to be_an Array }
    it { expect(a_get('/project/My_Project/jobs')).to have_been_made }
  end
end
