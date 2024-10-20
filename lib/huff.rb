# frozen_string_literal: true
require 'pqueue'
require_relative "huff/version"

module Huff
  class Error < StandardError; end

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
    huffman_tree = build_huffman_tree(create_occurrences_map(text))
    codes = get_char_codes(huffman_tree)
    text.each_char.map { |char| codes[char] }.join
  end

  def decode(bits, tree)
    text = ""
    cur_node = tree
    bits.each_char do |bit|
      cur_node = bit == '0' ? cur_node.left : cur_node.right
      if cur_node.char
        text += cur_node.char
        cur_node = tree
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

  def build_huffman_tree(occurrences_map)
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
