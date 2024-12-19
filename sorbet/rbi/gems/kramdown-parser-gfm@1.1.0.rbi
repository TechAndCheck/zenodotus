# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `kramdown-parser-gfm` gem.
# Please instead update this file by running `bin/tapioca gem kramdown-parser-gfm`.


# source://kramdown-parser-gfm//lib/kramdown/parser/gfm/options.rb#10
module Kramdown
  class << self
    # source://kramdown/2.4.0/lib/kramdown/document.rb#49
    def data_dir; end
  end
end

# source://kramdown-parser-gfm//lib/kramdown/parser/gfm/options.rb#11
module Kramdown::Options
  class << self
    # source://kramdown/2.4.0/lib/kramdown/options.rb#72
    def defaults; end

    # source://kramdown/2.4.0/lib/kramdown/options.rb#51
    def define(name, type, default, desc, &block); end

    # source://kramdown/2.4.0/lib/kramdown/options.rb#67
    def defined?(name); end

    # source://kramdown/2.4.0/lib/kramdown/options.rb#62
    def definitions; end

    # source://kramdown/2.4.0/lib/kramdown/options.rb#82
    def merge(hash); end

    # source://kramdown/2.4.0/lib/kramdown/options.rb#96
    def parse(name, data); end

    # source://kramdown/2.4.0/lib/kramdown/options.rb#141
    def simple_array_validator(val, name, size = T.unsafe(nil)); end

    # source://kramdown/2.4.0/lib/kramdown/options.rb#158
    def simple_hash_validator(val, name); end

    # source://kramdown/2.4.0/lib/kramdown/options.rb#122
    def str_to_sym(data); end
  end
end

# source://kramdown-parser-gfm//lib/kramdown/parser/gfm.rb#16
module Kramdown::Parser; end

# This class provides a parser implementation for the GFM dialect of Markdown.
#
# source://kramdown-parser-gfm//lib/kramdown/parser/gfm.rb#19
class Kramdown::Parser::GFM < ::Kramdown::Parser::Kramdown
  # @return [GFM] a new instance of GFM
  #
  # source://kramdown-parser-gfm//lib/kramdown/parser/gfm.rb#25
  def initialize(source, options); end

  # source://kramdown-parser-gfm//lib/kramdown/parser/gfm.rb#108
  def generate_gfm_header_id(text); end

  # Returns the value of attribute paragraph_end.
  #
  # source://kramdown-parser-gfm//lib/kramdown/parser/gfm.rb#23
  def paragraph_end; end

  # source://kramdown-parser-gfm//lib/kramdown/parser/gfm.rb#55
  def parse; end

  # Copied from kramdown/parser/kramdown/header.rb, removed the first line
  #
  # source://kramdown-parser-gfm//lib/kramdown/parser/gfm.rb#125
  def parse_atx_header_gfm_quirk; end

  # To handle task-lists we override the parse method for lists, converting matching text into
  # checkbox input elements where necessary (as well as applying classes to the ul/ol and li
  # elements).
  #
  # source://kramdown-parser-gfm//lib/kramdown/parser/gfm.rb#163
  def parse_list; end

  # source://kramdown-parser-gfm//lib/kramdown/parser/gfm.rb#142
  def parse_strikethrough_gfm; end

  # source://kramdown-parser-gfm//lib/kramdown/parser/gfm.rb#60
  def update_elements(element); end

  # Update the raw text for automatic ID generation.
  #
  # source://kramdown-parser-gfm//lib/kramdown/parser/gfm.rb#77
  def update_raw_text(item); end

  private

  # source://kramdown-parser-gfm//lib/kramdown/parser/gfm.rb#200
  def update_text_type(element, child); end

  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

# source://kramdown-parser-gfm//lib/kramdown/parser/gfm.rb#120
Kramdown::Parser::GFM::ATX_HEADER_START = T.let(T.unsafe(nil), Regexp)

# source://kramdown-parser-gfm//lib/kramdown/parser/gfm.rb#190
Kramdown::Parser::GFM::ESCAPED_CHARS_GFM = T.let(T.unsafe(nil), Regexp)

# source://kramdown-parser-gfm//lib/kramdown/parser/gfm.rb#135
Kramdown::Parser::GFM::FENCED_CODEBLOCK_MATCH = T.let(T.unsafe(nil), Regexp)

# source://kramdown-parser-gfm//lib/kramdown/parser/gfm.rb#134
Kramdown::Parser::GFM::FENCED_CODEBLOCK_START = T.let(T.unsafe(nil), Regexp)

# source://kramdown-parser-gfm//lib/kramdown/parser/gfm.rb#158
Kramdown::Parser::GFM::LIST_TYPES = T.let(T.unsafe(nil), Array)

# source://kramdown-parser-gfm//lib/kramdown/parser/gfm.rb#106
Kramdown::Parser::GFM::NON_WORD_RE = T.let(T.unsafe(nil), Regexp)

# source://kramdown-parser-gfm//lib/kramdown/parser/gfm.rb#193
Kramdown::Parser::GFM::PARAGRAPH_END_GFM = T.let(T.unsafe(nil), Regexp)

# source://kramdown-parser-gfm//lib/kramdown/parser/gfm.rb#138
Kramdown::Parser::GFM::STRIKETHROUGH_DELIM = T.let(T.unsafe(nil), Regexp)

# source://kramdown-parser-gfm//lib/kramdown/parser/gfm.rb#139
Kramdown::Parser::GFM::STRIKETHROUGH_MATCH = T.let(T.unsafe(nil), Regexp)

# source://kramdown-parser-gfm//lib/kramdown/parser/gfm.rb#21
Kramdown::Parser::GFM::VERSION = T.let(T.unsafe(nil), String)
