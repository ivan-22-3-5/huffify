# frozen_string_literal: true
require_relative '../lib/huffify'

RSpec.describe Huffify do
  it "has a version number" do
    expect(Huffify::VERSION).not_to be nil
  end

  describe '#create_occurrences_map' do
    let(:occurrences_map) { Huffify.send(:create_occurrences_map, text) }

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

  describe '#build_huffman_tree' do
    it 'builds a tree for an empty string' do
      result = Huffify.send(:build_huffman_tree, '')
      expect(result).to be_nil
    end

    it 'builds a tree for a single character string' do
      result = Huffify.send(:build_huffman_tree, 'aaaa')

      expect(result.char).to eq('a')
      expect(result.frequency).to eq(4)
      expect(result.left).to be_nil
      expect(result.right).to be_nil
    end

    it 'builds a correct tree for a string with two distinct characters' do
      result = Huffify.send(:build_huffman_tree, 'aabb')

      expect(result.frequency).to eq(4)
      expect(result.left.char).to eq('a')
      expect(result.left.frequency).to eq(2)
      expect(result.right.char).to eq('b')
      expect(result.right.frequency).to eq(2)
    end

    it 'builds a correct tree for a string with more than two distinct characters' do
      result = Huffify.send(:build_huffman_tree, 'abc')

      expect(result.frequency).to eq(3)
      expect(result.left).to_not be_nil
      expect(result.right).to_not be_nil

      chars = [result.left.char, result.right.char].compact + [result.left.left&.char, result.left.right&.char, result.right.left&.char, result.right.right&.char].compact
      expect(chars.sort).to eq(['a', 'b', 'c'])
    end

    it 'builds a correct tree for a complex string' do
      result = Huffify.send(:build_huffman_tree, 'aaaabbcc')

      expect(result.frequency).to eq(8)

      expect(result.left.frequency).to eq(4)
      expect(result.right.frequency).to eq(4)
    end
  end

  describe '.encode' do
    it 'encodes an empty string' do
      result = Huffify.encode('')
      expect(result[:encoded_text]).to eq('')
      expect(result[:huffman_tree]).to be_nil
    end

    it 'encodes a string with a single character' do
      result = Huffify.encode('aaaa')
      expect(result[:encoded_text]).to eq('0000')
      expect(result[:huffman_tree].char).to eq('a')
      expect(result[:huffman_tree].frequency).to eq(4)
    end

    it 'encodes a string with two characters' do
      result = Huffify.encode('aabb')

      expect(result[:encoded_text]).to eq('0011')
    end

    it 'encodes a complex string' do
      result = Huffify.encode('aaaabbcc')
      expect(result[:encoded_text]).to eq("000010101111")
    end
  end

  describe '.decode' do
    it 'decodes an empty string' do
      result = Huffify.encode('')
      decoded_text = Huffify.decode(result[:encoded_text], result[:huffman_tree])
      expect(decoded_text).to eq('')
    end

    it 'decodes a string with a single character' do
      result = Huffify.encode('aaaa')
      decoded_text = Huffify.decode(result[:encoded_text], result[:huffman_tree])
      expect(decoded_text).to eq('aaaa')
    end

    it 'decodes a string with two characters' do
      result = Huffify.encode('aabb')
      decoded_text = Huffify.decode(result[:encoded_text], result[:huffman_tree])
      expect(decoded_text).to eq('aabb')
    end

    it 'decodes a complex string' do
      result = Huffify.encode('aaaabbcc')
      decoded_text = Huffify.decode(result[:encoded_text], result[:huffman_tree])
      expect(decoded_text).to eq('aaaabbcc')
    end
  end
end
