# Huffify
Huffify is a Ruby gem that provides functionality to encode and decode text data using Huffman encoding, a lossless data compression algorithm. Huffman encoding efficiently compresses data by assigning shorter codes to more frequent symbols and longer codes to less frequent symbols.

## Installation

To install the gem, add this line to your application's Gemfile:

```ruby
gem 'huffify'
```

Then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install huffify
```

## Usage

### Basic Encoding and Decoding

Here's how you can use the gem to encode and decode a string using Huffman encoding:

```ruby
require 'huffify'
text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."

result = encode(text)

decoded_text = decode(result[:encoded_text], result[:huffman_tree])

decoded_text == text  # true

```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
