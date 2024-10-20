# frozen_string_literal: true

require_relative "lib/huff/version"

Gem::Specification.new do |spec|
  spec.name = "huff"
  spec.version = Huff::VERSION
  spec.authors = ["Ivan Mihun"]
  spec.email = ["vsk76090@gmail.com"]

  spec.summary = "A Ruby gem for lossless data compression using Huffman encoding."
  spec.description = "Huff is a Ruby gem that provides functionality to encode and decode text data using Huffman encoding, a lossless data compression algorithm. Huffman encoding efficiently compresses data by assigning shorter codes to more frequent symbols and longer codes to less frequent symbols."
  spec.homepage = "https://github.com/ivan-22-3-5/huff"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ivan-22-3-5/huff"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "pqueue", "~> 2.1.0"

end
