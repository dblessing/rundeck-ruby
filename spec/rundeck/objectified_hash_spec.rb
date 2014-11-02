require 'spec_helper'

describe Rundeck::ObjectifiedHash do
  before do
    @hash = { a: 1, b: 2 }
    @obj_hash = Rundeck::ObjectifiedHash.new(@hash)
  end
  subject { @obj_hash }

  its(:a) { is_expected.to eq(@hash[:a]) }
  its(:b) { is_expected.to eq(@hash[:b]) }

  describe '#to_hash' do
    subject { @obj_hash.to_hash }

    it { is_expected.to eq(@hash) }
  end

  describe '#to_h' do
    subject { @obj_hash.to_hash }

    it { is_expected.to eq(@hash) }
  end

  context 'with nested hashes' do
    before do
      @hash = { a: 1, b: { c: 2, d: { e: 3 } } }
      @obj_hash = Rundeck::ObjectifiedHash.new(@hash)
    end
    subject { @obj_hash }

    describe 'b' do
      subject { @obj_hash.b }

      it { is_expected.to be_a Rundeck::ObjectifiedHash }
      its(:c) { is_expected.to eq(@hash[:b][:c]) }

      describe 'd' do
        subject { @obj_hash.b.d }

        it { is_expected.to be_a Rundeck::ObjectifiedHash }
        its(:e) { is_expected.to eq(@hash[:b][:d][:e]) }
      end
    end
  end

  context 'with arrays of hashes' do
    before do
      @hash = { a: 1, b: [{ c: 2, d: 3 }, { e: 4, f: 5 }] }
      @obj_hash = Rundeck::ObjectifiedHash.new(@hash)
    end
    subject { @obj_hash }

    describe 'b' do
      subject { @obj_hash.b }

      it { is_expected.to be_an Array }
      its('first') { is_expected.to be_a Rundeck::ObjectifiedHash }
      its('first.c') { is_expected.to eq(2) }
    end
  end
end
