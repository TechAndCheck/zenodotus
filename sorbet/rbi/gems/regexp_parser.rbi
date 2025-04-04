# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: false
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/regexp_parser/all/regexp_parser.rbi
#
# regexp_parser-2.1.1

class Regexp
end
class Regexp::Parser
  def active_opts; end
  def anchor(token); end
  def assign_effective_number(exp); end
  def assign_referenced_expressions; end
  def backref(token); end
  def captured_group_count_at_level; end
  def captured_group_counts; end
  def captured_group_counts=(arg0); end
  def close_completed_character_set_range; end
  def close_group; end
  def close_set; end
  def conditional(token); end
  def conditional_nesting; end
  def conditional_nesting=(arg0); end
  def count_captured_group; end
  def decrease_nesting; end
  def escape(token); end
  def extract_options(input, options); end
  def free_space(token); end
  def group(token); end
  def increase_level(exp); end
  def intersection(token); end
  def interval(target_node, token); end
  def keep(token); end
  def literal(token); end
  def meta(token); end
  def negate_set; end
  def nest(exp); end
  def nest_conditional(exp); end
  def nesting; end
  def nesting=(arg0); end
  def node; end
  def node=(arg0); end
  def open_group(token); end
  def open_set(token); end
  def options_group(token); end
  def options_stack; end
  def options_stack=(arg0); end
  def parse(input, syntax = nil, options: nil, &block); end
  def parse_token(token); end
  def posixclass(token); end
  def property(token); end
  def quantifier(token); end
  def range(token); end
  def root; end
  def root=(arg0); end
  def self.parse(input, syntax = nil, options: nil, &block); end
  def sequence_operation(klass, token); end
  def set(token); end
  def switching_options; end
  def switching_options=(arg0); end
  def total_captured_group_count; end
  def type(token); end
  def update_transplanted_subtree(exp, new_parent); end
  include Regexp::Expression
  include Regexp::Expression::UnicodeProperty
end
class Regexp::Token < Struct
  def conditional_level; end
  def conditional_level=(_); end
  def length; end
  def level; end
  def level=(_); end
  def next; end
  def next=(arg0); end
  def offset; end
  def previous; end
  def previous=(arg0); end
  def self.[](*arg0); end
  def self.inspect; end
  def self.members; end
  def self.new(*arg0); end
  def set_level; end
  def set_level=(_); end
  def te; end
  def te=(_); end
  def text; end
  def text=(_); end
  def token; end
  def token=(_); end
  def ts; end
  def ts=(_); end
  def type; end
  def type=(_); end
end
class Regexp::Parser::Error < StandardError
end
class Regexp::Scanner
  def append_literal(data, ts, te); end
  def block; end
  def block=(arg0); end
  def char_pos; end
  def char_pos=(arg0); end
  def conditional_stack; end
  def conditional_stack=(arg0); end
  def copy(data, ts, te); end
  def emit(type, token, text); end
  def emit_literal; end
  def emit_meta_control_sequence(data, ts, te, token); end
  def emit_options(text); end
  def free_spacing; end
  def free_spacing=(arg0); end
  def free_spacing?(input_object, options); end
  def group_depth; end
  def group_depth=(arg0); end
  def in_group?; end
  def in_set?; end
  def literal; end
  def literal=(arg0); end
  def scan(input_object, options: nil, &block); end
  def self.long_prop_map; end
  def self.scan(input_object, options: nil, &block); end
  def self.short_prop_map; end
  def set_depth; end
  def set_depth=(arg0); end
  def spacing_stack; end
  def spacing_stack=(arg0); end
  def tokens; end
  def tokens=(arg0); end
  def validation_error(type, what, reason); end
end
class Regexp::Scanner::ScannerError < Regexp::Parser::Error
end
class Regexp::Scanner::ValidationError < Regexp::Parser::Error
  def initialize(reason); end
end
class Regexp::Scanner::PrematureEndError < Regexp::Scanner::ScannerError
  def initialize(where = nil); end
end
class Regexp::Scanner::InvalidSequenceError < Regexp::Scanner::ValidationError
  def initialize(what = nil, where = nil); end
end
class Regexp::Scanner::InvalidGroupError < Regexp::Scanner::ValidationError
  def initialize(what, reason); end
end
class Regexp::Scanner::InvalidGroupOption < Regexp::Scanner::ValidationError
  def initialize(option, text); end
end
class Regexp::Scanner::InvalidBackrefError < Regexp::Scanner::ValidationError
  def initialize(what, reason); end
end
class Regexp::Scanner::UnknownUnicodePropertyError < Regexp::Scanner::ValidationError
  def initialize(name); end
end
module Regexp::Syntax
  def comparable_version(name); end
  def const_missing(const_name); end
  def fallback_version_class(version); end
  def inherit_from_version(parent_version, new_version); end
  def new(name); end
  def self.comparable_version(name); end
  def self.const_missing(const_name); end
  def self.fallback_version_class(version); end
  def self.inherit_from_version(parent_version, new_version); end
  def self.new(name); end
  def self.specified_versions; end
  def self.supported?(name); end
  def self.version_class(version); end
  def self.version_const_name(version_string); end
  def self.warn_if_future_version(const_name); end
  def specified_versions; end
  def supported?(name); end
  def version_class(version); end
  def version_const_name(version_string); end
  def warn_if_future_version(const_name); end
end
module Regexp::Syntax::Token
end
module Regexp::Syntax::Token::Anchor
end
module Regexp::Syntax::Token::Assertion
end
module Regexp::Syntax::Token::Backreference
end
module Regexp::Syntax::Token::SubexpressionCall
end
module Regexp::Syntax::Token::PosixClass
end
module Regexp::Syntax::Token::CharacterSet
end
module Regexp::Syntax::Token::CharacterType
end
module Regexp::Syntax::Token::Conditional
end
module Regexp::Syntax::Token::Escape
end
module Regexp::Syntax::Token::Group
end
module Regexp::Syntax::Token::Keep
end
module Regexp::Syntax::Token::Meta
end
module Regexp::Syntax::Token::Quantifier
end
module Regexp::Syntax::Token::UnicodeProperty
end
module Regexp::Syntax::Token::UnicodeProperty::Category
end
module Regexp::Syntax::Token::Literal
end
module Regexp::Syntax::Token::FreeSpace
end
class Regexp::Syntax::NotImplementedError < Regexp::Syntax::SyntaxError
  def initialize(syntax, type, token); end
end
class Regexp::Syntax::Base
  def check!(type, token); end
  def check?(type, token); end
  def excludes(type, tokens); end
  def features; end
  def implementations(type); end
  def implements!(type, token); end
  def implements(type, tokens); end
  def implements?(type, token); end
  def initialize; end
  def normalize(type, token); end
  def normalize_backref(type, token); end
  def normalize_group(type, token); end
  def self.inspect; end
  include Regexp::Syntax::Token
end
class Regexp::Syntax::Any < Regexp::Syntax::Base
  def implements!(_type, _token); end
  def implements?(_type, _token); end
  def initialize; end
end
class Regexp::Syntax::InvalidVersionNameError < Regexp::Syntax::SyntaxError
  def initialize(name); end
end
class Regexp::Syntax::UnknownSyntaxNameError < Regexp::Syntax::SyntaxError
  def initialize(name); end
end
class Regexp::Syntax::V1_8_6 < Regexp::Syntax::Base
  def initialize; end
end
class Regexp::Syntax::V1_9_1 < Regexp::Syntax::V1_8_6
  def initialize; end
end
class Regexp::Syntax::V1_9_3 < Regexp::Syntax::V1_9_1
  def initialize; end
end
class Regexp::Syntax::V1_9 < Regexp::Syntax::V1_9_3
end
class Regexp::Syntax::V2_0_0 < Regexp::Syntax::V1_9
  def initialize; end
end
class Regexp::Syntax::V2_1 < Regexp::Syntax::V2_0_0
end
class Regexp::Syntax::V2_2_0 < Regexp::Syntax::V2_1
  def initialize; end
end
class Regexp::Syntax::V2_2 < Regexp::Syntax::V2_2_0
end
class Regexp::Syntax::V2_3_0 < Regexp::Syntax::V2_2
  def initialize; end
end
class Regexp::Syntax::V2_3 < Regexp::Syntax::V2_3_0
end
class Regexp::Syntax::V2_4_0 < Regexp::Syntax::V2_3
  def initialize; end
end
class Regexp::Syntax::V2_4_1 < Regexp::Syntax::V2_4_0
  def initialize; end
end
class Regexp::Syntax::V2_4 < Regexp::Syntax::V2_4_1
end
class Regexp::Syntax::V2_5_0 < Regexp::Syntax::V2_4
  def initialize; end
end
class Regexp::Syntax::V2_5 < Regexp::Syntax::V2_5_0
end
class Regexp::Syntax::V2_6_0 < Regexp::Syntax::V2_5
  def initialize; end
end
class Regexp::Syntax::V2_6_2 < Regexp::Syntax::V2_6_0
  def initialize; end
end
class Regexp::Syntax::V2_6_3 < Regexp::Syntax::V2_6_2
  def initialize; end
end
class Regexp::Syntax::SyntaxError < Regexp::Parser::Error
end
class Regexp::Lexer
  def ascend(type, token); end
  def break_codepoint_list(token); end
  def break_literal(token); end
  def conditional_nesting; end
  def conditional_nesting=(arg0); end
  def descend(type, token); end
  def lex(input, syntax = nil, options: nil, &block); end
  def merge_condition(current); end
  def nesting; end
  def nesting=(arg0); end
  def self.lex(input, syntax = nil, options: nil, &block); end
  def self.scan(input, syntax = nil, options: nil, &block); end
  def set_nesting; end
  def set_nesting=(arg0); end
  def shift; end
  def shift=(arg0); end
  def tokens; end
  def tokens=(arg0); end
end
module Regexp::Expression
end
class Regexp::Expression::Quantifier
  def ==(other); end
  def eq(other); end
  def greedy?; end
  def initialize(token, text, min, max, mode); end
  def initialize_copy(orig); end
  def lazy?; end
  def max; end
  def min; end
  def mode; end
  def possessive?; end
  def reluctant?; end
  def text; end
  def to_h; end
  def to_s; end
  def to_str; end
  def token; end
end
class Regexp::Expression::Subexpression < Regexp::Expression::Base
  def <<(exp); end
  def [](*args, &block); end
  def at(*args, &block); end
  def dig(*indices); end
  def each(*args, &block); end
  def each_expression(include_self = nil); end
  def empty?(*args, &block); end
  def expressions; end
  def expressions=(arg0); end
  def fetch(*args, &block); end
  def flat_map(include_self = nil); end
  def index(*args, &block); end
  def initialize(token, options = nil); end
  def initialize_copy(orig); end
  def inner_match_length; end
  def join(*args, &block); end
  def last(*args, &block); end
  def length(*args, &block); end
  def match_length; end
  def strfre_tree(format = nil, include_self = nil, separator = nil); end
  def strfregexp_tree(format = nil, include_self = nil, separator = nil); end
  def te; end
  def to_h; end
  def to_s(format = nil); end
  def traverse(include_self = nil, &block); end
  def values_at(*args, &block); end
  def walk(include_self = nil, &block); end
  include Enumerable
end
class Regexp::Expression::Sequence < Regexp::Expression::Subexpression
  def quantify(token, text, min = nil, max = nil, mode = nil); end
  def self.add_to(subexpression, params = nil, active_opts = nil); end
  def self.at_levels(level, set_level, conditional_level); end
  def starts_at; end
  def ts; end
end
class Regexp::Expression::SequenceOperation < Regexp::Expression::Subexpression
  def <<(exp); end
  def add_sequence(active_opts = nil); end
  def operands; end
  def operator; end
  def sequences; end
  def starts_at; end
  def to_s(format = nil); end
  def ts; end
end
class Regexp::Expression::Alternative < Regexp::Expression::Sequence
end
class Regexp::Expression::Alternation < Regexp::Expression::SequenceOperation
  def alternatives; end
  def match_length; end
end
module Regexp::Expression::Anchor
end
class Regexp::Expression::Anchor::Base < Regexp::Expression::Base
  def match_length; end
end
class Regexp::Expression::Anchor::BeginningOfLine < Regexp::Expression::Anchor::Base
end
class Regexp::Expression::Anchor::EndOfLine < Regexp::Expression::Anchor::Base
end
class Regexp::Expression::Anchor::BeginningOfString < Regexp::Expression::Anchor::Base
end
class Regexp::Expression::Anchor::EndOfString < Regexp::Expression::Anchor::Base
end
class Regexp::Expression::Anchor::EndOfStringOrBeforeEndOfLine < Regexp::Expression::Anchor::Base
end
class Regexp::Expression::Anchor::WordBoundary < Regexp::Expression::Anchor::Base
end
class Regexp::Expression::Anchor::NonWordBoundary < Regexp::Expression::Anchor::Base
end
class Regexp::Expression::Anchor::MatchStart < Regexp::Expression::Anchor::Base
end
module Regexp::Expression::Backreference
end
class Regexp::Expression::Backreference::Base < Regexp::Expression::Base
  def initialize_copy(orig); end
  def match_length; end
  def referenced_expression; end
  def referenced_expression=(arg0); end
end
class Regexp::Expression::Backreference::Number < Regexp::Expression::Backreference::Base
  def initialize(token, options = nil); end
  def number; end
  def reference; end
end
class Regexp::Expression::Backreference::Name < Regexp::Expression::Backreference::Base
  def initialize(token, options = nil); end
  def name; end
  def reference; end
end
class Regexp::Expression::Backreference::NumberRelative < Regexp::Expression::Backreference::Number
  def effective_number; end
  def effective_number=(arg0); end
  def reference; end
end
class Regexp::Expression::Backreference::NumberCall < Regexp::Expression::Backreference::Number
end
class Regexp::Expression::Backreference::NameCall < Regexp::Expression::Backreference::Name
end
class Regexp::Expression::Backreference::NumberCallRelative < Regexp::Expression::Backreference::NumberRelative
end
class Regexp::Expression::Backreference::NumberRecursionLevel < Regexp::Expression::Backreference::Number
  def initialize(token, options = nil); end
  def recursion_level; end
end
class Regexp::Expression::Backreference::NameRecursionLevel < Regexp::Expression::Backreference::Name
  def initialize(token, options = nil); end
  def recursion_level; end
end
module Regexp::Expression::Conditional
end
class Regexp::Expression::Conditional::TooManyBranches < Regexp::Parser::Error
  def initialize; end
end
class Regexp::Expression::Conditional::Condition < Regexp::Expression::Base
  def initialize_copy(orig); end
  def match_length; end
  def reference; end
  def referenced_expression; end
  def referenced_expression=(arg0); end
end
class Regexp::Expression::Conditional::Branch < Regexp::Expression::Sequence
end
class Regexp::Expression::Conditional::Expression < Regexp::Expression::Subexpression
  def <<(exp); end
  def add_sequence(active_opts = nil); end
  def branch(active_opts = nil); end
  def branches; end
  def condition; end
  def condition=(exp); end
  def initialize_copy(orig); end
  def match_length; end
  def reference; end
  def referenced_expression; end
  def referenced_expression=(arg0); end
  def to_s(format = nil); end
end
module Regexp::Expression::EscapeSequence
end
class Regexp::Expression::EscapeSequence::Base < Regexp::Expression::Base
  def char; end
  def codepoint; end
  def match_length; end
end
class Regexp::Expression::EscapeSequence::Literal < Regexp::Expression::EscapeSequence::Base
  def char; end
end
class Regexp::Expression::EscapeSequence::AsciiEscape < Regexp::Expression::EscapeSequence::Base
end
class Regexp::Expression::EscapeSequence::Backspace < Regexp::Expression::EscapeSequence::Base
end
class Regexp::Expression::EscapeSequence::Bell < Regexp::Expression::EscapeSequence::Base
end
class Regexp::Expression::EscapeSequence::FormFeed < Regexp::Expression::EscapeSequence::Base
end
class Regexp::Expression::EscapeSequence::Newline < Regexp::Expression::EscapeSequence::Base
end
class Regexp::Expression::EscapeSequence::Return < Regexp::Expression::EscapeSequence::Base
end
class Regexp::Expression::EscapeSequence::Tab < Regexp::Expression::EscapeSequence::Base
end
class Regexp::Expression::EscapeSequence::VerticalTab < Regexp::Expression::EscapeSequence::Base
end
class Regexp::Expression::EscapeSequence::Hex < Regexp::Expression::EscapeSequence::Base
end
class Regexp::Expression::EscapeSequence::Codepoint < Regexp::Expression::EscapeSequence::Base
end
class Regexp::Expression::EscapeSequence::CodepointList < Regexp::Expression::EscapeSequence::Base
  def char; end
  def chars; end
  def codepoint; end
  def codepoints; end
  def match_length; end
end
class Regexp::Expression::EscapeSequence::Octal < Regexp::Expression::EscapeSequence::Base
  def char; end
end
class Regexp::Expression::EscapeSequence::AbstractMetaControlSequence < Regexp::Expression::EscapeSequence::Base
  def char; end
  def control_sequence_to_s(control_sequence); end
  def meta_char_to_codepoint(meta_char); end
end
class Regexp::Expression::EscapeSequence::Control < Regexp::Expression::EscapeSequence::AbstractMetaControlSequence
  def codepoint; end
end
class Regexp::Expression::EscapeSequence::Meta < Regexp::Expression::EscapeSequence::AbstractMetaControlSequence
  def codepoint; end
end
class Regexp::Expression::EscapeSequence::MetaControl < Regexp::Expression::EscapeSequence::AbstractMetaControlSequence
  def codepoint; end
end
class Regexp::Expression::FreeSpace < Regexp::Expression::Base
  def match_length; end
  def quantify(_token, _text, _min = nil, _max = nil, _mode = nil); end
end
class Regexp::Expression::Comment < Regexp::Expression::FreeSpace
end
class Regexp::Expression::WhiteSpace < Regexp::Expression::FreeSpace
  def merge(exp); end
end
module Regexp::Expression::Group
end
class Regexp::Expression::Group::Base < Regexp::Expression::Subexpression
  def capturing?; end
  def comment?; end
  def to_s(format = nil); end
end
class Regexp::Expression::Group::Passive < Regexp::Expression::Group::Base
  def implicit=(arg0); end
  def implicit?; end
  def initialize(*arg0); end
  def to_s(format = nil); end
end
class Regexp::Expression::Group::Absence < Regexp::Expression::Group::Base
  def match_length; end
end
class Regexp::Expression::Group::Atomic < Regexp::Expression::Group::Base
end
class Regexp::Expression::Group::Options < Regexp::Expression::Group::Base
  def initialize_copy(orig); end
  def option_changes; end
  def option_changes=(arg0); end
end
class Regexp::Expression::Group::Capture < Regexp::Expression::Group::Base
  def capturing?; end
  def identifier; end
  def number; end
  def number=(arg0); end
  def number_at_level; end
  def number_at_level=(arg0); end
end
class Regexp::Expression::Group::Named < Regexp::Expression::Group::Capture
  def identifier; end
  def initialize(token, options = nil); end
  def initialize_copy(orig); end
  def name; end
end
class Regexp::Expression::Group::Comment < Regexp::Expression::Group::Base
  def comment?; end
  def to_s(_format = nil); end
end
module Regexp::Expression::Assertion
end
class Regexp::Expression::Assertion::Base < Regexp::Expression::Group::Base
  def match_length; end
end
class Regexp::Expression::Assertion::Lookahead < Regexp::Expression::Assertion::Base
end
class Regexp::Expression::Assertion::NegativeLookahead < Regexp::Expression::Assertion::Base
end
class Regexp::Expression::Assertion::Lookbehind < Regexp::Expression::Assertion::Base
end
class Regexp::Expression::Assertion::NegativeLookbehind < Regexp::Expression::Assertion::Base
end
module Regexp::Expression::Keep
end
class Regexp::Expression::Keep::Mark < Regexp::Expression::Base
  def match_length; end
end
class Regexp::Expression::Literal < Regexp::Expression::Base
  def match_length; end
end
class Regexp::Expression::PosixClass < Regexp::Expression::Base
  def match_length; end
  def name; end
  def negative?; end
end
module Regexp::Expression::UnicodeProperty
end
class Regexp::Expression::UnicodeProperty::Base < Regexp::Expression::Base
  def match_length; end
  def name; end
  def negative?; end
  def shortcut; end
end
class Regexp::Expression::UnicodeProperty::Alnum < Regexp::Expression::UnicodeProperty::Base
end
class Regexp::Expression::UnicodeProperty::Alpha < Regexp::Expression::UnicodeProperty::Base
end
class Regexp::Expression::UnicodeProperty::Ascii < Regexp::Expression::UnicodeProperty::Base
end
class Regexp::Expression::UnicodeProperty::Blank < Regexp::Expression::UnicodeProperty::Base
end
class Regexp::Expression::UnicodeProperty::Cntrl < Regexp::Expression::UnicodeProperty::Base
end
class Regexp::Expression::UnicodeProperty::Digit < Regexp::Expression::UnicodeProperty::Base
end
class Regexp::Expression::UnicodeProperty::Graph < Regexp::Expression::UnicodeProperty::Base
end
class Regexp::Expression::UnicodeProperty::Lower < Regexp::Expression::UnicodeProperty::Base
end
class Regexp::Expression::UnicodeProperty::Print < Regexp::Expression::UnicodeProperty::Base
end
class Regexp::Expression::UnicodeProperty::Punct < Regexp::Expression::UnicodeProperty::Base
end
class Regexp::Expression::UnicodeProperty::Space < Regexp::Expression::UnicodeProperty::Base
end
class Regexp::Expression::UnicodeProperty::Upper < Regexp::Expression::UnicodeProperty::Base
end
class Regexp::Expression::UnicodeProperty::Word < Regexp::Expression::UnicodeProperty::Base
end
class Regexp::Expression::UnicodeProperty::Xdigit < Regexp::Expression::UnicodeProperty::Base
end
class Regexp::Expression::UnicodeProperty::XPosixPunct < Regexp::Expression::UnicodeProperty::Base
end
class Regexp::Expression::UnicodeProperty::Newline < Regexp::Expression::UnicodeProperty::Base
end
class Regexp::Expression::UnicodeProperty::Any < Regexp::Expression::UnicodeProperty::Base
end
class Regexp::Expression::UnicodeProperty::Assigned < Regexp::Expression::UnicodeProperty::Base
end
module Regexp::Expression::UnicodeProperty::Letter
end
class Regexp::Expression::UnicodeProperty::Letter::Base < Regexp::Expression::UnicodeProperty::Base
end
class Regexp::Expression::UnicodeProperty::Letter::Any < Regexp::Expression::UnicodeProperty::Letter::Base
end
class Regexp::Expression::UnicodeProperty::Letter::Cased < Regexp::Expression::UnicodeProperty::Letter::Base
end
class Regexp::Expression::UnicodeProperty::Letter::Uppercase < Regexp::Expression::UnicodeProperty::Letter::Base
end
class Regexp::Expression::UnicodeProperty::Letter::Lowercase < Regexp::Expression::UnicodeProperty::Letter::Base
end
class Regexp::Expression::UnicodeProperty::Letter::Titlecase < Regexp::Expression::UnicodeProperty::Letter::Base
end
class Regexp::Expression::UnicodeProperty::Letter::Modifier < Regexp::Expression::UnicodeProperty::Letter::Base
end
class Regexp::Expression::UnicodeProperty::Letter::Other < Regexp::Expression::UnicodeProperty::Letter::Base
end
module Regexp::Expression::UnicodeProperty::Mark
end
class Regexp::Expression::UnicodeProperty::Mark::Base < Regexp::Expression::UnicodeProperty::Base
end
class Regexp::Expression::UnicodeProperty::Mark::Any < Regexp::Expression::UnicodeProperty::Mark::Base
end
class Regexp::Expression::UnicodeProperty::Mark::Combining < Regexp::Expression::UnicodeProperty::Mark::Base
end
class Regexp::Expression::UnicodeProperty::Mark::Nonspacing < Regexp::Expression::UnicodeProperty::Mark::Base
end
class Regexp::Expression::UnicodeProperty::Mark::Spacing < Regexp::Expression::UnicodeProperty::Mark::Base
end
class Regexp::Expression::UnicodeProperty::Mark::Enclosing < Regexp::Expression::UnicodeProperty::Mark::Base
end
module Regexp::Expression::UnicodeProperty::Number
end
class Regexp::Expression::UnicodeProperty::Number::Base < Regexp::Expression::UnicodeProperty::Base
end
class Regexp::Expression::UnicodeProperty::Number::Any < Regexp::Expression::UnicodeProperty::Number::Base
end
class Regexp::Expression::UnicodeProperty::Number::Decimal < Regexp::Expression::UnicodeProperty::Number::Base
end
class Regexp::Expression::UnicodeProperty::Number::Letter < Regexp::Expression::UnicodeProperty::Number::Base
end
class Regexp::Expression::UnicodeProperty::Number::Other < Regexp::Expression::UnicodeProperty::Number::Base
end
module Regexp::Expression::UnicodeProperty::Punctuation
end
class Regexp::Expression::UnicodeProperty::Punctuation::Base < Regexp::Expression::UnicodeProperty::Base
end
class Regexp::Expression::UnicodeProperty::Punctuation::Any < Regexp::Expression::UnicodeProperty::Punctuation::Base
end
class Regexp::Expression::UnicodeProperty::Punctuation::Connector < Regexp::Expression::UnicodeProperty::Punctuation::Base
end
class Regexp::Expression::UnicodeProperty::Punctuation::Dash < Regexp::Expression::UnicodeProperty::Punctuation::Base
end
class Regexp::Expression::UnicodeProperty::Punctuation::Open < Regexp::Expression::UnicodeProperty::Punctuation::Base
end
class Regexp::Expression::UnicodeProperty::Punctuation::Close < Regexp::Expression::UnicodeProperty::Punctuation::Base
end
class Regexp::Expression::UnicodeProperty::Punctuation::Initial < Regexp::Expression::UnicodeProperty::Punctuation::Base
end
class Regexp::Expression::UnicodeProperty::Punctuation::Final < Regexp::Expression::UnicodeProperty::Punctuation::Base
end
class Regexp::Expression::UnicodeProperty::Punctuation::Other < Regexp::Expression::UnicodeProperty::Punctuation::Base
end
module Regexp::Expression::UnicodeProperty::Separator
end
class Regexp::Expression::UnicodeProperty::Separator::Base < Regexp::Expression::UnicodeProperty::Base
end
class Regexp::Expression::UnicodeProperty::Separator::Any < Regexp::Expression::UnicodeProperty::Separator::Base
end
class Regexp::Expression::UnicodeProperty::Separator::Space < Regexp::Expression::UnicodeProperty::Separator::Base
end
class Regexp::Expression::UnicodeProperty::Separator::Line < Regexp::Expression::UnicodeProperty::Separator::Base
end
class Regexp::Expression::UnicodeProperty::Separator::Paragraph < Regexp::Expression::UnicodeProperty::Separator::Base
end
module Regexp::Expression::UnicodeProperty::Symbol
end
class Regexp::Expression::UnicodeProperty::Symbol::Base < Regexp::Expression::UnicodeProperty::Base
end
class Regexp::Expression::UnicodeProperty::Symbol::Any < Regexp::Expression::UnicodeProperty::Symbol::Base
end
class Regexp::Expression::UnicodeProperty::Symbol::Math < Regexp::Expression::UnicodeProperty::Symbol::Base
end
class Regexp::Expression::UnicodeProperty::Symbol::Currency < Regexp::Expression::UnicodeProperty::Symbol::Base
end
class Regexp::Expression::UnicodeProperty::Symbol::Modifier < Regexp::Expression::UnicodeProperty::Symbol::Base
end
class Regexp::Expression::UnicodeProperty::Symbol::Other < Regexp::Expression::UnicodeProperty::Symbol::Base
end
module Regexp::Expression::UnicodeProperty::Codepoint
end
class Regexp::Expression::UnicodeProperty::Codepoint::Base < Regexp::Expression::UnicodeProperty::Base
end
class Regexp::Expression::UnicodeProperty::Codepoint::Any < Regexp::Expression::UnicodeProperty::Codepoint::Base
end
class Regexp::Expression::UnicodeProperty::Codepoint::Control < Regexp::Expression::UnicodeProperty::Codepoint::Base
end
class Regexp::Expression::UnicodeProperty::Codepoint::Format < Regexp::Expression::UnicodeProperty::Codepoint::Base
end
class Regexp::Expression::UnicodeProperty::Codepoint::Surrogate < Regexp::Expression::UnicodeProperty::Codepoint::Base
end
class Regexp::Expression::UnicodeProperty::Codepoint::PrivateUse < Regexp::Expression::UnicodeProperty::Codepoint::Base
end
class Regexp::Expression::UnicodeProperty::Codepoint::Unassigned < Regexp::Expression::UnicodeProperty::Codepoint::Base
end
class Regexp::Expression::UnicodeProperty::Age < Regexp::Expression::UnicodeProperty::Base
end
class Regexp::Expression::UnicodeProperty::Derived < Regexp::Expression::UnicodeProperty::Base
end
class Regexp::Expression::UnicodeProperty::Emoji < Regexp::Expression::UnicodeProperty::Base
end
class Regexp::Expression::UnicodeProperty::Script < Regexp::Expression::UnicodeProperty::Base
end
class Regexp::Expression::UnicodeProperty::Block < Regexp::Expression::UnicodeProperty::Base
end
class Regexp::Expression::Root < Regexp::Expression::Subexpression
  def self.build(options = nil); end
  def self.build_token; end
end
class Regexp::Expression::CharacterSet < Regexp::Expression::Subexpression
  def close; end
  def closed; end
  def closed=(arg0); end
  def closed?; end
  def initialize(token, options = nil); end
  def match_length; end
  def negate; end
  def negated?; end
  def negative; end
  def negative=(arg0); end
  def negative?; end
  def to_s(format = nil); end
end
class Regexp::Expression::CharacterSet::IntersectedSequence < Regexp::Expression::Sequence
  def match_length; end
end
class Regexp::Expression::CharacterSet::Intersection < Regexp::Expression::SequenceOperation
  def match_length; end
end
class Regexp::Expression::CharacterSet::Range < Regexp::Expression::Subexpression
  def <<(exp); end
  def complete?; end
  def match_length; end
  def starts_at; end
  def to_s(_format = nil); end
  def ts; end
end
module Regexp::Expression::CharacterType
end
class Regexp::Expression::CharacterType::Base < Regexp::Expression::Base
  def match_length; end
end
class Regexp::Expression::CharacterType::Any < Regexp::Expression::CharacterType::Base
end
class Regexp::Expression::CharacterType::Digit < Regexp::Expression::CharacterType::Base
end
class Regexp::Expression::CharacterType::NonDigit < Regexp::Expression::CharacterType::Base
end
class Regexp::Expression::CharacterType::Hex < Regexp::Expression::CharacterType::Base
end
class Regexp::Expression::CharacterType::NonHex < Regexp::Expression::CharacterType::Base
end
class Regexp::Expression::CharacterType::Word < Regexp::Expression::CharacterType::Base
end
class Regexp::Expression::CharacterType::NonWord < Regexp::Expression::CharacterType::Base
end
class Regexp::Expression::CharacterType::Space < Regexp::Expression::CharacterType::Base
end
class Regexp::Expression::CharacterType::NonSpace < Regexp::Expression::CharacterType::Base
end
class Regexp::Expression::CharacterType::Linebreak < Regexp::Expression::CharacterType::Base
end
class Regexp::Expression::CharacterType::ExtendedGrapheme < Regexp::Expression::CharacterType::Base
end
class Regexp::Expression::Base
  def =~(string, offset = nil); end
  def a?; end
  def ascii_classes?; end
  def attributes; end
  def base_length; end
  def case_insensitive?; end
  def coded_offset; end
  def conditional_level; end
  def conditional_level=(arg0); end
  def d?; end
  def default_classes?; end
  def extended?; end
  def free_spacing?; end
  def full_length; end
  def greedy?; end
  def i?; end
  def ignore_case?; end
  def initialize(token, options = nil); end
  def initialize_copy(orig); end
  def is?(test_token, test_type = nil); end
  def lazy?; end
  def level; end
  def level=(arg0); end
  def m?; end
  def match(string, offset = nil); end
  def match?(string); end
  def matches?(string); end
  def multiline?; end
  def nesting_level; end
  def nesting_level=(arg0); end
  def offset; end
  def one_of?(scope, top = nil); end
  def options; end
  def options=(arg0); end
  def possessive?; end
  def quantified?; end
  def quantifier; end
  def quantifier=(arg0); end
  def quantifier_affix(expression_format); end
  def quantify(token, text, min = nil, max = nil, mode = nil); end
  def quantity; end
  def reluctant?; end
  def repetitions; end
  def set_level; end
  def set_level=(arg0); end
  def starts_at; end
  def strfre(format = nil, indent_offset = nil, index = nil); end
  def strfregexp(format = nil, indent_offset = nil, index = nil); end
  def terminal?; end
  def text; end
  def text=(arg0); end
  def to_h; end
  def to_re(format = nil); end
  def to_s(format = nil); end
  def token; end
  def token=(arg0); end
  def ts; end
  def ts=(arg0); end
  def type; end
  def type=(arg0); end
  def type?(test_type); end
  def u?; end
  def unicode_classes?; end
  def unquantified_clone; end
  def x?; end
end
class Regexp::MatchLength
  def base_max; end
  def base_max=(arg0); end
  def base_min; end
  def base_min=(arg0); end
  def each(opts = nil); end
  def endless_each; end
  def exp_class; end
  def exp_class=(arg0); end
  def fixed?; end
  def include?(length); end
  def initialize(exp, opts = nil); end
  def inspect; end
  def max; end
  def max_rep; end
  def max_rep=(arg0); end
  def min; end
  def min_rep; end
  def min_rep=(arg0); end
  def minmax; end
  def reify; end
  def reify=(arg0); end
  def self.of(obj); end
  def test_regexp; end
  def to_re; end
  include Enumerable
end
class Regexp::Parser::ParserError < Regexp::Parser::Error
end
class Regexp::Parser::UnknownTokenTypeError < Regexp::Parser::ParserError
  def initialize(type, token); end
end
class Regexp::Parser::UnknownTokenError < Regexp::Parser::ParserError
  def initialize(type, token); end
end
