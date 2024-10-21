# frozen_string_literal: true
require_relative '../lib/huffify'

RSpec.describe Huffify do
  it "has a version number" do
    expect(Huffify::VERSION).not_to be nil
  end

  describe '#create_occurrences_map' do
    include Huffify
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

  describe '#build_huffman_tree' do
    include Huffify
    it 'builds a Huffman tree for a simple case' do
      occurrences_map = { 'a' => 5, 'b' => 9, 'c' => 12, 'd' => 13, 'e' => 16, 'f' => 45 }
      root = build_huffman_tree(occurrences_map)

      expect(root.frequency).to eq(100)
      expect(root.left.frequency).to eq(45)
      expect(root.right.frequency).to eq(55)
    end

    it 'handles a case with a single character' do
      occurrences_map = { 'x' => 10 }
      root = build_huffman_tree(occurrences_map)

      expect(root.char).to eq('x')
      expect(root.frequency).to eq(10)
      expect(root.left).to be_nil
      expect(root.right).to be_nil
    end

    it 'handles a case with two characters' do
      occurrences_map = { 'y' => 2, 'z' => 3 }
      root = build_huffman_tree(occurrences_map)

      expect(root.frequency).to eq(5)
      expect(root.left.frequency).to eq(2)
      expect(root.right.frequency).to eq(3)
    end

    it 'handles characters with equal frequency' do
      occurrences_map = { 'a' => 3, 'b' => 3, 'c' => 3 }
      root = build_huffman_tree(occurrences_map)

      expect(root.frequency).to eq(9)
      expect(root.left.frequency).to eq(3)
      expect(root.right.frequency).to eq(6)
    end

    it 'correctly structures the tree' do
      occurrences_map = { 'g' => 1, 'h' => 2, 'i' => 3 }
      root = build_huffman_tree(occurrences_map)

      expect(root.frequency).to eq(6)
      expect(root.left.frequency).to eq(3)
      expect(root.right.frequency).to eq(3)
    end
  end
end
