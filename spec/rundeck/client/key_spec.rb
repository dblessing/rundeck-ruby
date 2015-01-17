require 'spec_helper'

describe Rundeck::Client do
  describe '.keys' do
    context 'with a path containing multiple keys',
            vcr: { cassette_name: 'key/key_multiple' } do
      before do
        prepare do
          Rundeck.create_public_key('path/to/key', public_key)
          Rundeck.create_private_key('path/to/private_key', private_key)
        end
        @keys = Rundeck.keys('path/to')
      end
      subject { @keys }

      it { is_expected.to be_an Array }

      context 'the public key' do
        subject { @keys.detect { |key| key.name == 'key' } }

        its(:name) { is_expected.to eq('key') }
        its(:type) { is_expected.to eq('file') }
        it { is_expected.to respond_to(:url) }
        it { is_expected.to respond_to(:path) }

        describe '#resource_meta' do
          subject { @keys.detect { |key| key.name == 'key' }.resource_meta }

          its(:rundeck_content_type) do
            is_expected.to eq('application/pgp-key')
          end
        end
      end

      it 'expects a get to have been made' do
        expect(a_get('/storage/keys/path/to')).to have_been_made
      end
    end

    context 'with a path containing no keys',
            vcr: { cassette_name: 'key/key_error' } do
      specify do
        expect do
          Rundeck.keys('path/to/nowhere')
        end.to raise_error Rundeck::Error::NotFound
      end
    end

    context 'with a direct path to a key',
            vcr: { cassette_name: 'key/key_direct' } do
      specify do
        expect do
          Rundeck.keys('path/to/key')
        end.to raise_error(Rundeck::Error::InvalidAttributes,
                           'Please provide a key storage path that ' \
                           'isn\'t a direct path to a key')
      end
    end
  end

  describe '.key_metadata' do
    context 'with a direct path to a key',
            vcr: { cassette_name: 'key/metadata_direct' } do
      before do
        @key = Rundeck.key_metadata('path/to/key')
      end
      subject { @key }

      it { is_expected.to be_a Rundeck::ObjectifiedHash }
      its(:rundeck_content_type) { is_expected.to eq('application/pgp-key') }

      it 'expects a get to have been made' do
        expect(a_get('/storage/keys/path/to/key')).to have_been_made
      end
    end

    context 'with a path containing multiple keys',
            vcr: { cassette_name: 'key/metadata_multiple' } do
      specify do
        expect do
          Rundeck.key_metadata('path/to')
        end.to raise_error(Rundeck::Error::InvalidAttributes,
                           'Please provide a key storage path that ' \
                           'is a direct path to a key')
      end
    end
  end

  describe '.key_contents' do
    context 'with a direct path to a key',
            vcr: { cassette_name: 'key/contents_direct' } do
      before do
        @key = Rundeck.key_contents('path/to/key')
      end
      subject { @key }

      it { is_expected.to be_a Rundeck::ObjectifiedHash }
      its(:public_key) { is_expected.to include('ssh-rsa') }

      it 'expects a get to have been made' do
        expect(a_get('/storage/keys/path/to/key')).to have_been_made
      end
      it 'expects a get to have been made' do
        expect(a_get('/storage/keys/path/to/key', 'pgp-keys')).to have_been_made
      end
    end

    context 'with a path containing multiple keys',
            vcr: { cassette_name: 'key/contents_multiple' } do
      specify do
        expect do
          Rundeck.key_contents('path/to')
        end.to raise_error(Rundeck::Error::InvalidAttributes,
                           'Please provide a key storage path that ' \
                           'is a direct path to a key')
      end
    end

    context 'with a path to a private key',
            vcr: { cassette_name: 'key/contents_private' } do
      specify do
        expect do
          Rundeck.key_contents('path/to/private_key')
        end.to raise_error(Rundeck::Error::Unauthorized,
                           'You are not allowed to retrieve the contents ' \
                           'of a private key')
      end
    end
  end

  describe '.create_private_key',
           vcr: { cassette_name: 'key/create_private' } do
    before do
      @key = Rundeck.create_private_key('path/to/private_key2', private_key)
    end
    subject { @key }

    it { is_expected.to be_a Rundeck::ObjectifiedHash }
    its(:rundeck_key_type) { is_expected.to eq('private') }

    it 'expects a post to have been made' do
      expect(
        a_post('/storage/keys/path/to/private_key2')
      ).to have_been_made
    end
  end

  describe '.update_private_key',
           vcr: { cassette_name: 'key/update_private' } do
    before do
      @key = Rundeck.update_private_key('path/to/private_key2', private_key)
    end
    subject { @key }

    it { is_expected.to be_a Rundeck::ObjectifiedHash }
    its(:rundeck_key_type) { is_expected.to eq('private') }

    it 'expects a get to have been made' do
      expect(a_get('/storage/keys/path/to/private_key2')).to have_been_made
    end
    it 'expects a put to have been made' do
      expect(a_put('/storage/keys/path/to/private_key2')).to have_been_made
    end
  end

  describe '.create_public_key',
           vcr: { cassette_name: 'key/create_public' } do
    before do
      @key = Rundeck.create_public_key('path/to/public_key2', public_key)
    end
    subject { @key }

    it { is_expected.to be_a Rundeck::ObjectifiedHash }
    its(:rundeck_content_type) { is_expected.to eq('application/pgp-key') }

    it 'expects a post to have been made' do
      expect(
        a_post('/storage/keys/path/to/public_key2')
      ).to have_been_made
    end
  end

  describe '.update_public_key',
           vcr: { cassette_name: 'key/update_public' } do
    before do
      @key = Rundeck.update_public_key('path/to/public_key2', public_key)
    end
    subject { @key }

    it { is_expected.to be_a Rundeck::ObjectifiedHash }
    its(:rundeck_content_type) { is_expected.to eq('application/pgp-key') }

    it 'expects a get to have been made' do
      expect(a_get('/storage/keys/path/to/public_key2')).to have_been_made
    end
    it 'expects a put to have been made' do
      expect(a_put('/storage/keys/path/to/public_key2')).to have_been_made
    end
  end

  describe '.delete_key' do
    context 'with a valid' do
      before do
        @key = Rundeck.delete_key(path)
      end
      subject { @key }

      context 'public key path',
              vcr: { cassette_name: 'key/delete_public' } do
        let(:path) { 'path/to/public_key2' }

        it { is_expected.to be_nil }
        it 'expects a delete to have been made' do
          expect(a_delete('/storage/keys/path/to/public_key2')).to have_been_made
        end
      end

      context 'private key path',
              vcr: { cassette_name: 'key/delete_private' } do
        let(:path) { 'path/to/private_key2' }

        it { is_expected.to be_nil }
        it 'expects a delete to have been made' do
          expect(a_delete('/storage/keys/path/to/private_key2')).to have_been_made
        end
      end
    end

    context 'with a bad path',
            vcr: { cassette_name: 'key/delete_error' } do
      specify do
        expect do
          Rundeck.delete_key('path/to/nowhere')
        end.to raise_error Rundeck::Error::NotFound
      end
    end
  end
end
