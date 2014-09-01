require 'spec_helper'

describe Rundeck::Client do
  describe '#objectify' do
    subject { Rundeck::Client.new.objectify(result) }

    context 'result is a hash' do
      let(:result) { { a: 1, b: 2 } }
      it { is_expected.to be_a Rundeck::ObjectifiedHash }
    end

    context 'result is an array' do
      let(:result) { [{ a: 1, b: 2 }, { c: 3, d: 4 }] }

      it { is_expected.to be_a Array }
      its([0]) { is_expected.to be_a Rundeck::ObjectifiedHash }
      its([1]) { is_expected.to be_a Rundeck::ObjectifiedHash }
    end

  end
end
