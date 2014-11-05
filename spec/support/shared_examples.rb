shared_examples 'a job' do
  it { is_expected.to be_a Rundeck::ObjectifiedHash }
  it { is_expected.to respond_to(:id) }
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:group) }
  it { is_expected.to respond_to(:description) }
end

shared_examples 'a job with a project attribute' do
  it_behaves_like 'a job'
  it { is_expected.to respond_to(:project) }
end

shared_examples 'a job import' do
  it { is_expected.to be_a Rundeck::ObjectifiedHash }
  it { is_expected.to respond_to(:id) }
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:group) }
  it { is_expected.to respond_to(:project) }
  it { is_expected.to respond_to(:url) }
end

shared_examples 'an execution' do
  it { is_expected.to be_a Rundeck::ObjectifiedHash }
  it { is_expected.to respond_to(:user) }
  it { is_expected.to respond_to(:date_started) }
  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:argstring) }
end

shared_examples 'a past execution' do
  it_behaves_like 'an execution'
  it { is_expected.to respond_to(:date_ended) }
end
