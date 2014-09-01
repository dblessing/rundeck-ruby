require 'spec_helper'

describe Rundeck::Client do
  describe '#objectify' do
    subject { Rundeck::Client.new.objectify(result) }

    context 'when result' do
      context 'is a hash' do
        let(:result) { { a: 1, b: 2 } }
        it { is_expected.to be_a Rundeck::ObjectifiedHash }
      end

      context 'is an array' do
        let(:result) { [{ a: 1, b: 2 }, { c: 3, d: 4 }] }

        it { is_expected.to be_a Array }
        its([0]) { is_expected.to be_a Rundeck::ObjectifiedHash }
        its([1]) { is_expected.to be_a Rundeck::ObjectifiedHash }
      end

      context 'is a string' do
        it do
          expect do
            Rundeck::Client.new.objectify('string')
          end.to raise_error Rundeck::Error::Parsing,
                             "Couldn't parse a response body"
        end
      end
    end
  end
end
