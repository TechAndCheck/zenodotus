# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `amazing_print` gem.
# Please instead update this file by running `bin/tapioca gem amazing_print`.


class ActionView::Base
  include ::ERB::Escape
  include ::ActiveSupport::CoreExt::ERBUtil
  include ::ActiveSupport::CoreExt::ERBUtilPrivate
  include ::ActiveSupport::Benchmarkable
  include ::ActionView::Helpers::ActiveModelHelper
  include ::ActionView::Helpers::AssetUrlHelper
  include ::ActionView::Helpers::CaptureHelper
  include ::ActionView::Helpers::OutputSafetyHelper
  include ::ActionView::Helpers::TagHelper
  include ::ActionView::Helpers::AssetTagHelper
  include ::ActionView::Helpers::AtomFeedHelper
  include ::ActionView::Helpers::CacheHelper
  include ::ActionView::Helpers::ContentExfiltrationPreventionHelper
  include ::ActionView::Helpers::ControllerHelper
  include ::ActionView::Helpers::CspHelper
  include ::ActionView::Helpers::CsrfHelper
  include ::ActionView::Helpers::DateHelper
  include ::ActionView::Helpers::DebugHelper
  include ::ActionView::ModelNaming
  include ::ActionView::RecordIdentifier
  include ::ActionView::Helpers::FormOptionsHelper
  include ::ActionView::Helpers::JavaScriptHelper
  include ::ActionView::Helpers::NumberHelper
  include ::ActionView::Helpers::RenderingHelper
  include ::AmazingPrint::ActionView
end

# source://amazing_print//lib/amazing_print/custom_defaults.rb#3
module AmazingPrint
  class << self
    # @return [Boolean]
    #
    # source://amazing_print//lib/amazing_print/custom_defaults.rb#14
    def console?; end

    # Returns the value of attribute defaults.
    #
    # source://amazing_print//lib/amazing_print/custom_defaults.rb#5
    def defaults; end

    # Sets the attribute defaults
    #
    # @param value the value to set the attribute defaults to.
    #
    # source://amazing_print//lib/amazing_print/custom_defaults.rb#5
    def defaults=(_arg0); end

    # source://amazing_print//lib/amazing_print/custom_defaults.rb#22
    def diet_rb; end

    # Returns the value of attribute force_colors.
    #
    # source://amazing_print//lib/amazing_print/custom_defaults.rb#5
    def force_colors; end

    # Class accessor to force colorized output (ex. forked subprocess where TERM
    # might be dumb).
    # ---------------------------------------------------------------------------
    #
    # source://amazing_print//lib/amazing_print/custom_defaults.rb#10
    def force_colors!(colors: T.unsafe(nil)); end

    # Sets the attribute force_colors
    #
    # @param value the value to set the attribute force_colors to.
    #
    # source://amazing_print//lib/amazing_print/custom_defaults.rb#5
    def force_colors=(_arg0); end

    # source://amazing_print//lib/amazing_print/custom_defaults.rb#40
    def irb!; end

    # source://amazing_print//lib/amazing_print/custom_defaults.rb#46
    def pry!; end

    # @return [Boolean]
    #
    # source://amazing_print//lib/amazing_print/custom_defaults.rb#18
    def rails_console?; end

    # Reload the cached custom configurations.
    #
    # source://amazing_print//lib/amazing_print/custom_defaults.rb#53
    def reload!; end

    # source://amazing_print//lib/amazing_print/custom_defaults.rb#30
    def usual_rb; end

    # source://amazing_print//lib/amazing_print/version.rb#9
    def version; end

    private

    # Takes a value and returns true unless it is false or nil
    # This is an alternative to the less readable !!(value)
    # https://github.com/bbatsov/ruby-style-guide#no-bang-bang
    #
    # source://amazing_print//lib/amazing_print/custom_defaults.rb#62
    def boolean(value); end
  end
end

# source://amazing_print//lib/amazing_print/ext/action_view.rb#9
module AmazingPrint::ActionView
  # Use HTML colors and add default "debug_dump" class to the resulting HTML.
  #
  # source://amazing_print//lib/amazing_print/ext/action_view.rb#11
  def ap(object, options = T.unsafe(nil)); end

  # Use HTML colors and add default "debug_dump" class to the resulting HTML.
  #
  # source://amazing_print//lib/amazing_print/ext/action_view.rb#11
  def ap_debug(object, options = T.unsafe(nil)); end
end

# source://amazing_print//lib/amazing_print/ext/active_record.rb#9
module AmazingPrint::ActiveRecord
  # Add ActiveRecord class names to the dispatcher pipeline.
  # ------------------------------------------------------------------------------
  #
  # source://amazing_print//lib/amazing_print/ext/active_record.rb#17
  def cast_with_active_record(object, type); end

  private

  # Format ActiveModel error object.
  # ------------------------------------------------------------------------------
  #
  # source://amazing_print//lib/amazing_print/ext/active_record.rb#76
  def awesome_active_model_error(object); end

  # Format ActiveRecord class object.
  # ------------------------------------------------------------------------------
  #
  # source://amazing_print//lib/amazing_print/ext/active_record.rb#63
  def awesome_active_record_class(object); end

  # Format ActiveRecord instance object.
  #
  # NOTE: by default only instance attributes (i.e. columns) are shown. To format
  # ActiveRecord instance as regular object showing its instance variables and
  # accessors use :raw => true option:
  #
  # ap record, :raw => true
  #
  # ------------------------------------------------------------------------------
  #
  # source://amazing_print//lib/amazing_print/ext/active_record.rb#44
  def awesome_active_record_instance(object); end

  class << self
    # @private
    #
    # source://amazing_print//lib/amazing_print/ext/active_record.rb#10
    def included(base); end
  end
end

# source://amazing_print//lib/amazing_print/ext/active_support.rb#9
module AmazingPrint::ActiveSupport
  # Format ActiveSupport::TimeWithZone as standard Time.
  # ------------------------------------------------------------------------------
  #
  # source://amazing_print//lib/amazing_print/ext/active_support.rb#29
  def awesome_active_support_time(object); end

  # Format HashWithIndifferentAccess as standard Hash.
  # ------------------------------------------------------------------------------
  #
  # source://amazing_print//lib/amazing_print/ext/active_support.rb#35
  def awesome_hash_with_indifferent_access(object); end

  # source://amazing_print//lib/amazing_print/ext/active_support.rb#15
  def cast_with_active_support(object, type); end

  class << self
    # @private
    #
    # source://amazing_print//lib/amazing_print/ext/active_support.rb#10
    def included(base); end
  end
end

# source://amazing_print//lib/amazing_print/colorize.rb#8
module AmazingPrint::Colorize
  # Pick the color and apply it to the given string as necessary.
  # ------------------------------------------------------------------------------
  #
  # source://amazing_print//lib/amazing_print/colorize.rb#11
  def colorize(str, type); end
end

# source://amazing_print//lib/amazing_print/colors.rb#4
module AmazingPrint::Colors
  private

  # source://amazing_print//lib/amazing_print/colors.rb#25
  def blue(str, html = T.unsafe(nil)); end

  # source://amazing_print//lib/amazing_print/colors.rb#32
  def blueish(str, html = T.unsafe(nil)); end

  # source://amazing_print//lib/amazing_print/colors.rb#25
  def cyan(str, html = T.unsafe(nil)); end

  # source://amazing_print//lib/amazing_print/colors.rb#32
  def cyanish(str, html = T.unsafe(nil)); end

  # source://amazing_print//lib/amazing_print/colors.rb#25
  def gray(str, html = T.unsafe(nil)); end

  # source://amazing_print//lib/amazing_print/colors.rb#32
  def grayish(str, html = T.unsafe(nil)); end

  # source://amazing_print//lib/amazing_print/colors.rb#25
  def green(str, html = T.unsafe(nil)); end

  # source://amazing_print//lib/amazing_print/colors.rb#32
  def greenish(str, html = T.unsafe(nil)); end

  # source://amazing_print//lib/amazing_print/colors.rb#25
  def purple(str, html = T.unsafe(nil)); end

  # source://amazing_print//lib/amazing_print/colors.rb#32
  def purpleish(str, html = T.unsafe(nil)); end

  # source://amazing_print//lib/amazing_print/colors.rb#25
  def red(str, html = T.unsafe(nil)); end

  # source://amazing_print//lib/amazing_print/colors.rb#32
  def redish(str, html = T.unsafe(nil)); end

  # source://amazing_print//lib/amazing_print/colors.rb#25
  def white(str, html = T.unsafe(nil)); end

  # source://amazing_print//lib/amazing_print/colors.rb#32
  def whiteish(str, html = T.unsafe(nil)); end

  # source://amazing_print//lib/amazing_print/colors.rb#25
  def yellow(str, html = T.unsafe(nil)); end

  # source://amazing_print//lib/amazing_print/colors.rb#32
  def yellowish(str, html = T.unsafe(nil)); end

  class << self
    # source://amazing_print//lib/amazing_print/colors.rb#25
    def blue(str, html = T.unsafe(nil)); end

    # source://amazing_print//lib/amazing_print/colors.rb#32
    def blueish(str, html = T.unsafe(nil)); end

    # source://amazing_print//lib/amazing_print/colors.rb#25
    def cyan(str, html = T.unsafe(nil)); end

    # source://amazing_print//lib/amazing_print/colors.rb#32
    def cyanish(str, html = T.unsafe(nil)); end

    # source://amazing_print//lib/amazing_print/colors.rb#25
    def gray(str, html = T.unsafe(nil)); end

    # source://amazing_print//lib/amazing_print/colors.rb#32
    def grayish(str, html = T.unsafe(nil)); end

    # source://amazing_print//lib/amazing_print/colors.rb#25
    def green(str, html = T.unsafe(nil)); end

    # source://amazing_print//lib/amazing_print/colors.rb#32
    def greenish(str, html = T.unsafe(nil)); end

    # source://amazing_print//lib/amazing_print/colors.rb#25
    def purple(str, html = T.unsafe(nil)); end

    # source://amazing_print//lib/amazing_print/colors.rb#32
    def purpleish(str, html = T.unsafe(nil)); end

    # source://amazing_print//lib/amazing_print/colors.rb#25
    def red(str, html = T.unsafe(nil)); end

    # source://amazing_print//lib/amazing_print/colors.rb#32
    def redish(str, html = T.unsafe(nil)); end

    # source://amazing_print//lib/amazing_print/colors.rb#25
    def white(str, html = T.unsafe(nil)); end

    # source://amazing_print//lib/amazing_print/colors.rb#32
    def whiteish(str, html = T.unsafe(nil)); end

    # source://amazing_print//lib/amazing_print/colors.rb#25
    def yellow(str, html = T.unsafe(nil)); end

    # source://amazing_print//lib/amazing_print/colors.rb#32
    def yellowish(str, html = T.unsafe(nil)); end
  end
end

# source://amazing_print//lib/amazing_print/formatter.rb#11
class AmazingPrint::Formatter
  include ::AmazingPrint::Colorize
  include ::AmazingPrint::ActiveRecord
  include ::AmazingPrint::ActiveSupport
  include ::AmazingPrint::Nokogiri
  include ::AmazingPrint::OpenStruct

  # @return [Formatter] a new instance of Formatter
  #
  # source://amazing_print//lib/amazing_print/formatter.rb#18
  def initialize(inspector); end

  # Hook this when adding custom formatters. Check out lib/amazing_print/ext
  # directory for custom formatters that ship with amazing_print.
  # ------------------------------------------------------------------------------
  #
  # source://amazing_print//lib/amazing_print/ext/ostruct.rb#15
  def cast(object, type); end

  # source://amazing_print//lib/amazing_print/formatter.rb#37
  def cast_without_active_record(_object, type); end

  # source://amazing_print//lib/amazing_print/ext/active_record.rb#17
  def cast_without_active_support(object, type); end

  # source://amazing_print//lib/amazing_print/ext/active_support.rb#15
  def cast_without_nokogiri(object, type); end

  # source://amazing_print//lib/amazing_print/ext/nokogiri.rb#17
  def cast_without_ostruct(object, type); end

  # Main entry point to format an object.
  # ------------------------------------------------------------------------------
  #
  # source://amazing_print//lib/amazing_print/formatter.rb#25
  def format(object, type = T.unsafe(nil)); end

  # Returns the value of attribute inspector.
  #
  # source://amazing_print//lib/amazing_print/formatter.rb#14
  def inspector; end

  # Returns the value of attribute options.
  #
  # source://amazing_print//lib/amazing_print/formatter.rb#14
  def options; end

  private

  # source://amazing_print//lib/amazing_print/formatter.rb#71
  def awesome_array(a); end

  # source://amazing_print//lib/amazing_print/formatter.rb#55
  def awesome_bigdecimal(n); end

  # source://amazing_print//lib/amazing_print/formatter.rb#96
  def awesome_class(c); end

  # source://amazing_print//lib/amazing_print/formatter.rb#104
  def awesome_dir(d); end

  # source://amazing_print//lib/amazing_print/formatter.rb#100
  def awesome_file(f); end

  # source://amazing_print//lib/amazing_print/formatter.rb#79
  def awesome_hash(h); end

  # source://amazing_print//lib/amazing_print/formatter.rb#91
  def awesome_method(m); end

  # source://amazing_print//lib/amazing_print/formatter.rb#83
  def awesome_object(o); end

  # source://amazing_print//lib/amazing_print/formatter.rb#61
  def awesome_rational(n); end

  # Catch all method to format an arbitrary object.
  # ------------------------------------------------------------------------------
  #
  # source://amazing_print//lib/amazing_print/formatter.rb#45
  def awesome_self(object, type); end

  # source://amazing_print//lib/amazing_print/formatter.rb#75
  def awesome_set(s); end

  # source://amazing_print//lib/amazing_print/formatter.rb#67
  def awesome_simple(o, type, inspector = T.unsafe(nil)); end

  # source://amazing_print//lib/amazing_print/formatter.rb#87
  def awesome_struct(s); end

  # source://amazing_print//lib/amazing_print/formatter.rb#91
  def awesome_unboundmethod(m); end

  # Utility methods.
  # ------------------------------------------------------------------------------
  #
  # source://amazing_print//lib/amazing_print/formatter.rb#110
  def convert_to_hash(object); end

  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

# source://amazing_print//lib/amazing_print/formatter.rb#16
AmazingPrint::Formatter::CORE_FORMATTERS = T.let(T.unsafe(nil), Array)

# source://amazing_print//lib/amazing_print/formatters.rb#4
module AmazingPrint::Formatters; end

# source://amazing_print//lib/amazing_print/formatters/array_formatter.rb#7
class AmazingPrint::Formatters::ArrayFormatter < ::AmazingPrint::Formatters::BaseFormatter
  # @return [ArrayFormatter] a new instance of ArrayFormatter
  #
  # source://amazing_print//lib/amazing_print/formatters/array_formatter.rb#10
  def initialize(array, inspector); end

  # Returns the value of attribute array.
  #
  # source://amazing_print//lib/amazing_print/formatters/array_formatter.rb#8
  def array; end

  # source://amazing_print//lib/amazing_print/formatters/array_formatter.rb#17
  def format; end

  # Returns the value of attribute inspector.
  #
  # source://amazing_print//lib/amazing_print/formatters/array_formatter.rb#8
  def inspector; end

  # Returns the value of attribute options.
  #
  # source://amazing_print//lib/amazing_print/formatters/array_formatter.rb#8
  def options; end

  private

  # source://amazing_print//lib/amazing_print/formatters/array_formatter.rb#59
  def array_prefix(iteration, width); end

  # source://amazing_print//lib/amazing_print/formatters/array_formatter.rb#113
  def find_method(name); end

  # source://amazing_print//lib/amazing_print/formatters/array_formatter.rb#51
  def generate_printable_array; end

  # source://amazing_print//lib/amazing_print/formatters/array_formatter.rb#71
  def generate_printable_tuples; end

  # source://amazing_print//lib/amazing_print/formatters/array_formatter.rb#104
  def generate_tuple(name); end

  # source://amazing_print//lib/amazing_print/formatters/array_formatter.rb#129
  def generic_prefix(iteration, width, padding = T.unsafe(nil)); end

  # source://amazing_print//lib/amazing_print/formatters/array_formatter.rb#63
  def methods_array; end

  # @return [Boolean]
  #
  # source://amazing_print//lib/amazing_print/formatters/array_formatter.rb#29
  def methods_array?; end

  # source://amazing_print//lib/amazing_print/formatters/array_formatter.rb#41
  def multiline_array; end

  # source://amazing_print//lib/amazing_print/formatters/array_formatter.rb#94
  def name_and_args_width; end

  # source://amazing_print//lib/amazing_print/formatters/array_formatter.rb#33
  def simple_array; end

  # source://amazing_print//lib/amazing_print/formatters/array_formatter.rb#100
  def tuple_prefix(iteration, width); end

  # source://amazing_print//lib/amazing_print/formatters/array_formatter.rb#79
  def tuple_template(item); end

  # source://amazing_print//lib/amazing_print/formatters/array_formatter.rb#90
  def tuples; end

  # source://amazing_print//lib/amazing_print/formatters/array_formatter.rb#137
  def width(items); end

  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

# source://amazing_print//lib/amazing_print/formatters/base_formatter.rb#7
class AmazingPrint::Formatters::BaseFormatter
  include ::AmazingPrint::Colorize

  # source://amazing_print//lib/amazing_print/formatters/base_formatter.rb#130
  def align(value, width); end

  # source://amazing_print//lib/amazing_print/formatters/base_formatter.rb#36
  def get_limit_size; end

  # source://amazing_print//lib/amazing_print/formatters/base_formatter.rb#120
  def indent(n = T.unsafe(nil)); end

  # Indentation related methods
  # -----------------------------------------
  #
  # source://amazing_print//lib/amazing_print/formatters/base_formatter.rb#109
  def indentation; end

  # source://amazing_print//lib/amazing_print/formatters/base_formatter.rb#113
  def indented(&blk); end

  # source://amazing_print//lib/amazing_print/formatters/base_formatter.rb#45
  def limited(data, width, is_hash: T.unsafe(nil)); end

  # source://amazing_print//lib/amazing_print/formatters/base_formatter.rb#67
  def method_tuple(method); end

  # source://amazing_print//lib/amazing_print/formatters/base_formatter.rb#124
  def outdent; end

  # To support limited output, for example:
  #
  # ap ('a'..'z').to_a, :limit => 3
  # [
  #     [ 0] "a",
  #     [ 1] .. [24],
  #     [25] "z"
  # ]
  #
  # ap (1..100).to_a, :limit => true # Default limit is 7.
  # [
  #     [ 0] 1,
  #     [ 1] 2,
  #     [ 2] 3,
  #     [ 3] .. [96],
  #     [97] 98,
  #     [98] 99,
  #     [99] 100
  # ]
  # ------------------------------------------------------------------------------
  #
  # @return [Boolean]
  #
  # source://amazing_print//lib/amazing_print/formatters/base_formatter.rb#32
  def should_be_limited?; end

  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

# source://amazing_print//lib/amazing_print/formatters/base_formatter.rb#10
AmazingPrint::Formatters::BaseFormatter::DEFAULT_LIMIT_SIZE = T.let(T.unsafe(nil), Integer)

# precompute common indentations
#
# source://amazing_print//lib/amazing_print/formatters/base_formatter.rb#118
AmazingPrint::Formatters::BaseFormatter::INDENT_CACHE = T.let(T.unsafe(nil), Array)

# source://amazing_print//lib/amazing_print/formatters/class_formatter.rb#7
class AmazingPrint::Formatters::ClassFormatter < ::AmazingPrint::Formatters::BaseFormatter
  # @return [ClassFormatter] a new instance of ClassFormatter
  #
  # source://amazing_print//lib/amazing_print/formatters/class_formatter.rb#10
  def initialize(klass, inspector); end

  # source://amazing_print//lib/amazing_print/formatters/class_formatter.rb#17
  def format; end

  # Returns the value of attribute inspector.
  #
  # source://amazing_print//lib/amazing_print/formatters/class_formatter.rb#8
  def inspector; end

  # Returns the value of attribute klass.
  #
  # source://amazing_print//lib/amazing_print/formatters/class_formatter.rb#8
  def klass; end

  # Returns the value of attribute options.
  #
  # source://amazing_print//lib/amazing_print/formatters/class_formatter.rb#8
  def options; end

  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

# source://amazing_print//lib/amazing_print/formatters/dir_formatter.rb#10
class AmazingPrint::Formatters::DirFormatter < ::AmazingPrint::Formatters::BaseFormatter
  # @return [DirFormatter] a new instance of DirFormatter
  #
  # source://amazing_print//lib/amazing_print/formatters/dir_formatter.rb#13
  def initialize(dir, inspector); end

  # Returns the value of attribute dir.
  #
  # source://amazing_print//lib/amazing_print/formatters/dir_formatter.rb#11
  def dir; end

  # source://amazing_print//lib/amazing_print/formatters/dir_formatter.rb#20
  def format; end

  # source://amazing_print//lib/amazing_print/formatters/dir_formatter.rb#25
  def info; end

  # Returns the value of attribute inspector.
  #
  # source://amazing_print//lib/amazing_print/formatters/dir_formatter.rb#11
  def inspector; end

  # Returns the value of attribute options.
  #
  # source://amazing_print//lib/amazing_print/formatters/dir_formatter.rb#11
  def options; end

  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

# source://amazing_print//lib/amazing_print/formatters/file_formatter.rb#10
class AmazingPrint::Formatters::FileFormatter < ::AmazingPrint::Formatters::BaseFormatter
  # @return [FileFormatter] a new instance of FileFormatter
  #
  # source://amazing_print//lib/amazing_print/formatters/file_formatter.rb#13
  def initialize(file, inspector); end

  # Returns the value of attribute file.
  #
  # source://amazing_print//lib/amazing_print/formatters/file_formatter.rb#11
  def file; end

  # source://amazing_print//lib/amazing_print/formatters/file_formatter.rb#20
  def format; end

  # source://amazing_print//lib/amazing_print/formatters/file_formatter.rb#25
  def info; end

  # Returns the value of attribute inspector.
  #
  # source://amazing_print//lib/amazing_print/formatters/file_formatter.rb#11
  def inspector; end

  # Returns the value of attribute options.
  #
  # source://amazing_print//lib/amazing_print/formatters/file_formatter.rb#11
  def options; end

  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

# source://amazing_print//lib/amazing_print/formatters/hash_formatter.rb#7
class AmazingPrint::Formatters::HashFormatter < ::AmazingPrint::Formatters::BaseFormatter
  # @return [HashFormatter] a new instance of HashFormatter
  #
  # source://amazing_print//lib/amazing_print/formatters/hash_formatter.rb#10
  def initialize(hash, inspector); end

  # source://amazing_print//lib/amazing_print/formatters/hash_formatter.rb#17
  def format; end

  # Returns the value of attribute hash.
  #
  # source://amazing_print//lib/amazing_print/formatters/hash_formatter.rb#8
  def hash; end

  # Returns the value of attribute inspector.
  #
  # source://amazing_print//lib/amazing_print/formatters/hash_formatter.rb#8
  def inspector; end

  # Returns the value of attribute options.
  #
  # source://amazing_print//lib/amazing_print/formatters/hash_formatter.rb#8
  def options; end

  private

  # source://amazing_print//lib/amazing_print/formatters/hash_formatter.rb#29
  def empty_hash; end

  # source://amazing_print//lib/amazing_print/formatters/hash_formatter.rb#62
  def left_width(keys); end

  # source://amazing_print//lib/amazing_print/formatters/hash_formatter.rb#68
  def max_key_width(keys); end

  # source://amazing_print//lib/amazing_print/formatters/hash_formatter.rb#37
  def multiline_hash; end

  # @return [Boolean]
  #
  # source://amazing_print//lib/amazing_print/formatters/hash_formatter.rb#33
  def multiline_hash?; end

  # source://amazing_print//lib/amazing_print/formatters/hash_formatter.rb#98
  def plain_single_line; end

  # source://amazing_print//lib/amazing_print/formatters/hash_formatter.rb#94
  def pre_ruby19_syntax(key, value, width); end

  # source://amazing_print//lib/amazing_print/formatters/hash_formatter.rb#45
  def printable_hash; end

  # source://amazing_print//lib/amazing_print/formatters/hash_formatter.rb#72
  def printable_keys; end

  # source://amazing_print//lib/amazing_print/formatters/hash_formatter.rb#88
  def ruby19_syntax(key, value, width); end

  # source://amazing_print//lib/amazing_print/formatters/hash_formatter.rb#41
  def simple_hash; end

  # @return [Boolean]
  #
  # source://amazing_print//lib/amazing_print/formatters/hash_formatter.rb#84
  def symbol?(key); end

  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

# source://amazing_print//lib/amazing_print/formatters/method_formatter.rb#7
class AmazingPrint::Formatters::MethodFormatter < ::AmazingPrint::Formatters::BaseFormatter
  # @return [MethodFormatter] a new instance of MethodFormatter
  #
  # source://amazing_print//lib/amazing_print/formatters/method_formatter.rb#10
  def initialize(method, inspector); end

  # source://amazing_print//lib/amazing_print/formatters/method_formatter.rb#17
  def format; end

  # Returns the value of attribute inspector.
  #
  # source://amazing_print//lib/amazing_print/formatters/method_formatter.rb#8
  def inspector; end

  # Returns the value of attribute method.
  #
  # source://amazing_print//lib/amazing_print/formatters/method_formatter.rb#8
  def method; end

  # Returns the value of attribute options.
  #
  # source://amazing_print//lib/amazing_print/formatters/method_formatter.rb#8
  def options; end

  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

# source://amazing_print//lib/amazing_print/formatters/object_formatter.rb#7
class AmazingPrint::Formatters::ObjectFormatter < ::AmazingPrint::Formatters::BaseFormatter
  # @return [ObjectFormatter] a new instance of ObjectFormatter
  #
  # source://amazing_print//lib/amazing_print/formatters/object_formatter.rb#10
  def initialize(object, inspector); end

  # source://amazing_print//lib/amazing_print/formatters/object_formatter.rb#18
  def format; end

  # Returns the value of attribute inspector.
  #
  # source://amazing_print//lib/amazing_print/formatters/object_formatter.rb#8
  def inspector; end

  # Returns the value of attribute object.
  #
  # source://amazing_print//lib/amazing_print/formatters/object_formatter.rb#8
  def object; end

  # Returns the value of attribute options.
  #
  # source://amazing_print//lib/amazing_print/formatters/object_formatter.rb#8
  def options; end

  # Returns the value of attribute variables.
  #
  # source://amazing_print//lib/amazing_print/formatters/object_formatter.rb#8
  def variables; end

  private

  # source://amazing_print//lib/amazing_print/formatters/object_formatter.rb#64
  def awesome_instance; end

  # source://amazing_print//lib/amazing_print/formatters/object_formatter.rb#75
  def left_aligned; end

  # @return [Boolean]
  #
  # source://amazing_print//lib/amazing_print/formatters/object_formatter.rb#60
  def valid_instance_var?(variable_name); end

  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

# source://amazing_print//lib/amazing_print/formatters/simple_formatter.rb#7
class AmazingPrint::Formatters::SimpleFormatter < ::AmazingPrint::Formatters::BaseFormatter
  # @return [SimpleFormatter] a new instance of SimpleFormatter
  #
  # source://amazing_print//lib/amazing_print/formatters/simple_formatter.rb#10
  def initialize(string, type, inspector); end

  # source://amazing_print//lib/amazing_print/formatters/simple_formatter.rb#18
  def format; end

  # Returns the value of attribute inspector.
  #
  # source://amazing_print//lib/amazing_print/formatters/simple_formatter.rb#8
  def inspector; end

  # Returns the value of attribute options.
  #
  # source://amazing_print//lib/amazing_print/formatters/simple_formatter.rb#8
  def options; end

  # Returns the value of attribute string.
  #
  # source://amazing_print//lib/amazing_print/formatters/simple_formatter.rb#8
  def string; end

  # Returns the value of attribute type.
  #
  # source://amazing_print//lib/amazing_print/formatters/simple_formatter.rb#8
  def type; end

  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

# source://amazing_print//lib/amazing_print/formatters/struct_formatter.rb#7
class AmazingPrint::Formatters::StructFormatter < ::AmazingPrint::Formatters::BaseFormatter
  # @return [StructFormatter] a new instance of StructFormatter
  #
  # source://amazing_print//lib/amazing_print/formatters/struct_formatter.rb#10
  def initialize(struct, inspector); end

  # source://amazing_print//lib/amazing_print/formatters/struct_formatter.rb#18
  def format; end

  # Returns the value of attribute inspector.
  #
  # source://amazing_print//lib/amazing_print/formatters/struct_formatter.rb#8
  def inspector; end

  # Returns the value of attribute options.
  #
  # source://amazing_print//lib/amazing_print/formatters/struct_formatter.rb#8
  def options; end

  # Returns the value of attribute struct.
  #
  # source://amazing_print//lib/amazing_print/formatters/struct_formatter.rb#8
  def struct; end

  # Returns the value of attribute variables.
  #
  # source://amazing_print//lib/amazing_print/formatters/struct_formatter.rb#8
  def variables; end

  private

  # source://amazing_print//lib/amazing_print/formatters/struct_formatter.rb#60
  def awesome_instance; end

  # source://amazing_print//lib/amazing_print/formatters/struct_formatter.rb#68
  def left_aligned; end

  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

# source://amazing_print//lib/amazing_print/indentator.rb#4
class AmazingPrint::Indentator
  # @return [Indentator] a new instance of Indentator
  #
  # source://amazing_print//lib/amazing_print/indentator.rb#7
  def initialize(indentation); end

  # source://amazing_print//lib/amazing_print/indentator.rb#12
  def indent; end

  # Returns the value of attribute indentation.
  #
  # source://amazing_print//lib/amazing_print/indentator.rb#5
  def indentation; end

  # Returns the value of attribute shift_width.
  #
  # source://amazing_print//lib/amazing_print/indentator.rb#5
  def shift_width; end

  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

# source://amazing_print//lib/amazing_print/inspector.rb#14
class AmazingPrint::Inspector
  # @return [Inspector] a new instance of Inspector
  #
  # source://amazing_print//lib/amazing_print/inspector.rb#28
  def initialize(options = T.unsafe(nil)); end

  # Dispatcher that detects data nesting and invokes object-aware formatter.
  # ---------------------------------------------------------------------------
  #
  # source://amazing_print//lib/amazing_print/inspector.rb#85
  def awesome(object); end

  # Return true if we are to colorize the output.
  # ---------------------------------------------------------------------------
  #
  # @return [Boolean]
  #
  # source://amazing_print//lib/amazing_print/inspector.rb#100
  def colorize?; end

  # source://amazing_print//lib/amazing_print/inspector.rb#75
  def current_indentation; end

  # source://amazing_print//lib/amazing_print/inspector.rb#79
  def increase_indentation(&blk); end

  # Returns the value of attribute indentator.
  #
  # source://amazing_print//lib/amazing_print/inspector.rb#15
  def indentator; end

  # Sets the attribute indentator
  #
  # @param value the value to set the attribute indentator to.
  #
  # source://amazing_print//lib/amazing_print/inspector.rb#15
  def indentator=(_arg0); end

  # Returns the value of attribute options.
  #
  # source://amazing_print//lib/amazing_print/inspector.rb#15
  def options; end

  # Sets the attribute options
  #
  # @param value the value to set the attribute options to.
  #
  # source://amazing_print//lib/amazing_print/inspector.rb#15
  def options=(_arg0); end

  private

  # @return [Boolean]
  #
  # source://amazing_print//lib/amazing_print/inspector.rb#182
  def dotfile_readable?(dotfile); end

  # source://amazing_print//lib/amazing_print/inspector.rb#162
  def find_dotfile; end

  # This method needs to be mocked during testing so that it always loads
  # predictable values
  # ---------------------------------------------------------------------------
  #
  # source://amazing_print//lib/amazing_print/inspector.rb#175
  def load_dotfile; end

  # Load ~/.aprc file with custom defaults that override default options.
  # ---------------------------------------------------------------------------
  #
  # source://amazing_print//lib/amazing_print/inspector.rb#190
  def merge_custom_defaults!; end

  # Update @options by first merging the :color hash and then the remaining
  # keys.
  # ---------------------------------------------------------------------------
  #
  # source://amazing_print//lib/amazing_print/inspector.rb#157
  def merge_options!(options = T.unsafe(nil)); end

  # Format nested data, for example:
  #   arr = [1, 2]; arr << arr
  #   => [1,2, [...]]
  #   hash = { :a => 1 }; hash[:b] = hash
  #   => { :a => 1, :b => {...} }
  # ---------------------------------------------------------------------------
  #
  # source://amazing_print//lib/amazing_print/inspector.rb#125
  def nested(object); end

  # Turn class name into symbol, ex: Hello::World => :hello_world. Classes
  # that inherit from Array, Hash, File, Dir, and Struct are treated as the
  # base class.
  # ---------------------------------------------------------------------------
  #
  # source://amazing_print//lib/amazing_print/inspector.rb#143
  def printable(object); end

  # ---------------------------------------------------------------------------
  #
  # source://amazing_print//lib/amazing_print/inspector.rb#135
  def unnested(object); end

  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end

    # Unload the cached dotfile and load it again.
    #
    # source://amazing_print//lib/amazing_print/inspector.rb#22
    def reload_dotfile; end
  end
end

# source://amazing_print//lib/amazing_print/inspector.rb#17
AmazingPrint::Inspector::AP = T.let(T.unsafe(nil), Symbol)

# source://amazing_print//lib/amazing_print/core_ext/logger.rb#9
module AmazingPrint::Logger
  # Add ap method to logger
  # ------------------------------------------------------------------------------
  #
  # source://amazing_print//lib/amazing_print/core_ext/logger.rb#12
  def ap(object, options = T.unsafe(nil)); end
end

# source://amazing_print//lib/amazing_print/ext/nokogiri.rb#9
module AmazingPrint::Nokogiri
  # ------------------------------------------------------------------------------
  #
  # source://amazing_print//lib/amazing_print/ext/nokogiri.rb#27
  def awesome_nokogiri_xml_node(object); end

  # Add Nokogiri XML Node and NodeSet names to the dispatcher pipeline.
  # ------------------------------------------------------------------------------
  #
  # source://amazing_print//lib/amazing_print/ext/nokogiri.rb#17
  def cast_with_nokogiri(object, type); end

  class << self
    # @private
    #
    # source://amazing_print//lib/amazing_print/ext/nokogiri.rb#10
    def included(base); end
  end
end

# source://amazing_print//lib/amazing_print/ext/ostruct.rb#9
module AmazingPrint::OpenStruct
  # source://amazing_print//lib/amazing_print/ext/ostruct.rb#21
  def awesome_open_struct_instance(object); end

  # source://amazing_print//lib/amazing_print/ext/ostruct.rb#15
  def cast_with_ostruct(object, type); end

  class << self
    # @private
    #
    # source://amazing_print//lib/amazing_print/ext/ostruct.rb#10
    def included(base); end
  end
end

# source://amazing_print//lib/amazing_print/core_ext/awesome_method_array.rb#17
module AwesomeMethodArray
  # source://amazing_print//lib/amazing_print/core_ext/awesome_method_array.rb#24
  def &(other); end

  # source://amazing_print//lib/amazing_print/core_ext/awesome_method_array.rb#18
  def -(other); end

  # Intercepting Array#grep needs a special treatment since grep accepts
  # an optional block.
  #
  # source://amazing_print//lib/amazing_print/core_ext/awesome_method_array.rb#34
  def grep(pattern, &blk); end
end

module ERB::Escape
  private

  def html_escape(_arg0); end

  class << self
    def html_escape(_arg0); end
  end
end

# source://amazing_print//lib/amazing_print/core_ext/kernel.rb#8
module Kernel
  # source://amazing_print//lib/amazing_print/core_ext/kernel.rb#9
  def ai(options = T.unsafe(nil)); end

  # source://amazing_print//lib/amazing_print/core_ext/kernel.rb#20
  def amazing_print(object, options = T.unsafe(nil)); end

  # source://amazing_print//lib/amazing_print/core_ext/kernel.rb#9
  def awesome_inspect(options = T.unsafe(nil)); end

  private

  # source://amazing_print//lib/amazing_print/core_ext/kernel.rb#20
  def ap(object, options = T.unsafe(nil)); end

  class << self
    # source://amazing_print//lib/amazing_print/core_ext/kernel.rb#20
    def ap(object, options = T.unsafe(nil)); end
  end
end

class Logger
  include ::AmazingPrint::Logger
end
