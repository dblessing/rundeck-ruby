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
              vcr: { cassette_name: 'token/tokens_single' } do
        it { is_expected.to be_a Rundeck::ObjectifiedHash }
        its(:token) { is_expected.to be_a Rundeck::ObjectifiedHash }
        its(:allusers) { is_expected.to eq('true') }

        it 'expects a get to have been made' do
          expect(a_get('/tokens')).to have_been_made
        end
      end

      context 'when multiple tokens are returned',
              vcr: { cassette_name: 'token/tokens_multiple' } do
        before { prepare { Rundeck.create_token('dev') } }

        it { is_expected.to be_a Rundeck::ObjectifiedHash }
        its(:token) { is_expected.to be_an Array }
        its(:allusers) { is_expected.to eq('true') }
      end
    end

    context 'when user is specified',
            vcr: { cassette_name: 'token/tokens_user' } do
      before { prepare { Rundeck.create_token('dev') } }
      let(:user) { 'dev' }

      it { is_expected.to be_a Rundeck::ObjectifiedHash }
      its(:user) { is_expected.to eq(user) }

      describe '#token' do
        subject { @tokens.token.first }

        it_behaves_like 'a token'
        its(:user) { is_expected.to eq(user) }
      end
    end
  end

  describe '.token' do
    context 'when a token exists', vcr: { cassette_name: 'token/token' } do
      before do
        @token = Rundeck.token(Rundeck.api_token)
      end
      subject { @token }

      it_behaves_like 'a token'

      it 'expects a get to have been made' do
        expect(a_get("/token/#{Rundeck.api_token}")).to have_been_made
      end
    end

    context 'when a token does not exist',
            vcr: { cassette_name: 'token/token_error' } do
      specify do
        expect do
          Rundeck.token('123456')
        end.to raise_error(Rundeck::Error::NotFound,
                           /Token does not exist: 123456/)
      end
    end
  end

  describe '.create_token' do
    context 'when the user exists',
            vcr: { cassette_name: 'token/token_create' } do
      before do
        @token = Rundeck.create_token('dev')
      end
      subject { @token }

      it_behaves_like 'a token'

      it 'expects a post to have been made' do
        expect(a_post('/tokens/dev')).to have_been_made
      end
    end
  end

  describe '.delete_token' do
    context 'when a token exists',
            vcr: { cassette_name: 'token/token_delete' } do
      before do
        VCR.use_cassette('token/tokens_user') do
          @dev_tokens = Rundeck.tokens('dev')
        end
        @token = Rundeck.delete_token(@dev_tokens.token.first.id)
      end
      subject { @token }

      it { is_expected.to be_nil }

      it 'expects a delete to have been made' do
        expect(
          a_delete("/token/#{@dev_tokens.token.first.id}")
        ).to have_been_made
      end
    end

    context 'when a token does not exist',
            vcr: { cassette_name: 'token/delete_error' } do
      specify do
        expect do
          Rundeck.delete_token('123456')
        end.to raise_error(Rundeck::Error::NotFound,
                           /Token does not exist: 123456/)
      end
    end
  end
end
