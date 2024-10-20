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
