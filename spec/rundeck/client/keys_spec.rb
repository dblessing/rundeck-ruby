require 'spec_helper'

describe Rundeck::Client do
  describe '.keys' do
    context 'with a path containing multiple keys' do
      before do
        stub_get('/storage/keys/', 'keys')
        @keys = Rundeck.keys
      end
      subject { @keys }

      it { is_expected.to be_an Array }
      it { expect(a_get('/storage/keys/')).to have_been_made }
    end

    context 'with a direct path to a key' do
      before do
        stub_get('/storage/keys/path/to/key1', 'key_public')
      end

      it do
        expect do
          Rundeck.keys('path/to/key1')
        end.to raise_error(Rundeck::Error::InvalidAttributes,
                           'Please provide a key storage path that ' \
                           'isn\'t a direct path to a key')
      end
    end
  end

  describe '.key_metadata' do
    context 'with a direct path to a key' do
      before do
        stub_get('/storage/keys/path/to/key1', 'key_public')
        @key = Rundeck.key_metadata('path/to/key1')
      end
      subject { @key }

      it { is_expected.to be_a Rundeck::ObjectifiedHash }
      it { expect(a_get('/storage/keys/path/to/key1')).to have_been_made }

    end

    context 'with a path containing multiple keys' do
      before do
        stub_get('/storage/keys/path/to/keys', 'keys')
      end

      it do
        expect do
          Rundeck.key_metadata('path/to/keys')
        end.to raise_error(Rundeck::Error::InvalidAttributes,
                           'Please provide a key storage path that ' \
                           'is a direct path to a key')
      end
    end
  end

  describe '.key_contents' do
    context 'with a direct path to a key' do
      before do
        stub_get('/storage/keys/path/to/key1', 'key_public')
        stub_get('/storage/keys/path/to/key1', 'key_contents', 'pgp-keys')
        @key = Rundeck.key_contents('path/to/key1')
      end
      subject { @key }

      it { is_expected.to be_a String }
      it { expect(a_get('/storage/keys/path/to/key1', 'pgp-keys')).to have_been_made }
    end

    context 'with a path containing multiple keys' do
      before do
        stub_get('/storage/keys/path/to/keys', 'keys')
      end

      it do
        expect do
          Rundeck.key_contents('path/to/keys')
        end.to raise_error(Rundeck::Error::InvalidAttributes,
                           'Please provide a key storage path that ' \
                           'is a direct path to a key')
      end
    end
  end

  describe '.create_private_key' do
    before do
      keystring = <<-EOD
-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: AES-128-CBC,E283774838299...
-----END RSA PRIVATE KEY-----
      EOD
      stub_post('/storage/keys/path/to/my_key', 'key_private')
      @key = Rundeck.create_private_key('path/to/my_key', keystring)
    end
    subject { @key }

    it { is_expected.to be_a Rundeck::ObjectifiedHash }
    it do
      expect(
        a_post('/storage/keys/path/to/my_key')
      ).to have_been_made
    end
  end
end
