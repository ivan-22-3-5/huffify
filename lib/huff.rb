# frozen_string_literal: true

require_relative "huff/version"

module Huff
  class Error < StandardError; end

  private

  def create_occurrences_map(text)
    occurrences_map = Hash.new(0)
    text.each_char { |char| occurrences_map[char] += 1 }
    occurrences_map
  end
end
