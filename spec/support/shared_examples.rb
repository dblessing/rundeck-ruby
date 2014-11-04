shared_examples 'a job' do
  it { is_expected.to respond_to(:id) }
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:group) }
  it { is_expected.to respond_to(:description) }
end

shared_examples 'a job import' do
  it { is_expected.to respond_to(:id) }
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:group) }
  it { is_expected.to respond_to(:project) }
  it { is_expected.to respond_to(:url) }
end
