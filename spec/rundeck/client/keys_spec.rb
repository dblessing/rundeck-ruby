require 'spec_helper'

describe Rundeck::Client do
  describe '.keys' do
    before do
      stub_get('/storage/keys/path/to/key1')
      @keys = Rundeck.keys('path/to/key1')
    end
    subject { @keys }

    it { is_expected.to be_an Array }
    it { expect(a_get('/storage/keys/path/to/key1')).to have_been_made }
  end

  describe '.create_private_key' do
    before do
      key = <<-EOD
-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: AES-128-CBC,E283774838299...
-----END RSA PRIVATE KEY-----
      EOD
      stub_post('/storage/keys/path/to/my_key', key)
      @key = Rundeck.create_private_key('path/to/my_key', key)
    end
    subject { @key }

    it { is_expected.to be_a Rundeck::ObjectifiedHash }
    it do
      expect(
        a_post('/storage/keys/path/to/my_key', key)
      ).to have_been_made
    end
  end
end
