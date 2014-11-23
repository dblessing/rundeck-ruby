require 'spec_helper'

describe Rundeck::Client do
  describe '.tokens' do
    before do
      @tokens = Rundeck.tokens(user)
    end
    subject { @tokens }

    context 'when user is nil' do
      let(:user) { nil }

      context 'when a single token is returned',
              vcr: { cassette_name: 'tokens_single' } do
        it { is_expected.to be_a Rundeck::ObjectifiedHash }
        its(:token) { is_expected.to be_a Rundeck::ObjectifiedHash }
        its(:allusers) { is_expected.to eq('true') }

        it 'expects a get to have been made' do
          expect(a_get('/tokens')).to have_been_made
        end
      end

      context 'when multiple tokens are returned',
              vcr: { cassette_name: 'tokens_multiple' } do
        it { is_expected.to be_a Rundeck::ObjectifiedHash }
        its(:token) { is_expected.to be_an Array }
        its(:allusers) { is_expected.to eq('true') }
      end
    end

    context 'when user is specified', vcr: { cassette_name: 'tokens_user' } do
      let(:user) { 'admin' }

      it { is_expected.to be_a Rundeck::ObjectifiedHash }
      its(:user) { is_expected.to eq('admin') }

      describe '#token' do
        subject { @tokens.token }

        it_behaves_like 'a token'
        its(:user) { is_expected.to eq('admin') }
      end
    end
  end

  describe '.token' do
    context 'when a token exists', vcr: { cassette_name: 'token' } do
      before do
        @token = Rundeck.token('cmJQYoy9EAsSd0905yNjKDNGs0ESIwEd')
      end
      subject { @token }

      it_behaves_like 'a token'

      it 'expects a get to have been made' do
        expect(a_get('/token/cmJQYoy9EAsSd0905yNjKDNGs0ESIwEd')).to have_been_made
      end
    end

    context 'when a token does not exist',
            vcr: { cassette_name: 'token_invalid' } do
      specify do
        expect do
          Rundeck.token('123456')
        end.to raise_error(Rundeck::Error::NotFound,
                           /Token does not exist: 123456/)
      end
    end
  end
end
