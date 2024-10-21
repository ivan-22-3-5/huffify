# frozen_string_literal: true
require 'pqueue'
require_relative "huff/version"

module Huff
  class HuffNode
    attr_accessor :char, :frequency, :left, :right

    def initialize(char, frequency, left = nil, right = nil)
      @char = char
      @frequency = frequency
      @left = left
      @right = right
    end
  end

  def encode(text)
    huffman_tree = build_huffman_tree(text)
    codes = get_char_codes(huffman_tree)
    { encoded_text: text.each_char.map { |char| codes[char] }.join, huffman_tree: huffman_tree }
  end

  def decode(bits, huffman_tree)
    text = ""
    cur_node = huffman_tree
    bits.each_char do |bit|
      cur_node = bit == '0' ? cur_node.left : cur_node.right
      if cur_node.char
        text += cur_node.char
        cur_node = huffman_tree
      end
    end
    text
  end

  private

  def create_occurrences_map(text)
    occurrences_map = Hash.new(0)
    text.each_char { |char| occurrences_map[char] += 1 }
    occurrences_map
  end

  def build_huffman_tree(text)
    occurrences_map = create_occurrences_map(text)
    pq = PQueue.new { |a, b| a.frequency < b.frequency }
    occurrences_map.each { |char, count| pq.push(HuffNode.new(char, count)) }
    until pq.size == 1
      first, second = pq.pop, pq.pop
      pq.push(HuffNode.new(nil, first.frequency + second.frequency, first, second))
    end
    pq.pop
  end

  def get_char_codes(node, code = '', codes = {})
    if node.char
      codes[node.char] = code
    else
      get_char_codes(node.left, code + '0', codes)
      get_char_codes(node.right, code + '1', codes)
    end
    codes
  end
end
