# frozen_string_literal: true
require_relative '../lib/huff'

RSpec.describe Huff do
  it "has a version number" do
    expect(Huff::VERSION).not_to be nil
  end

  describe 'create_occurrences_map' do
    include Huff
    let(:occurrences_map) { create_occurrences_map(text) }

    context 'when the input string is empty' do
      let(:text) { '' }

      it 'returns an empty hash' do
        expect(occurrences_map).to eq({})
      end
    end

    context 'when the input string has unique characters' do
      let(:text) { 'abc' }

      it 'returns a hash with character counts of 1' do
        expect(occurrences_map).to eq({ 'a' => 1, 'b' => 1, 'c' => 1 })
      end
    end

    context 'when the input string has repeated characters' do
      let(:text) { 'aabbcc' }

      it 'returns a hash with correct character counts' do
        expect(occurrences_map).to eq({ 'a' => 2, 'b' => 2, 'c' => 2 })
      end
    end

    context 'when the input string has mixed characters' do
      let(:text) { 'aabccdee' }

      it 'returns a hash with correct character counts' do
        expect(occurrences_map).to eq({ 'a' => 2, 'b' => 1, 'c' => 2, 'd' => 1, 'e' => 2 })
      end
    end

    context 'when the input string contains special characters' do
      let(:text) { '!!@@##$$' }

      it 'returns a hash with correct counts for special characters' do
        expect(occurrences_map).to eq({ '!' => 2, '@' => 2, '#' => 2, '$' => 2 })
      end
    end
  end
end
