# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `console` gem.
# Please instead update this file by running `bin/tapioca gem console`.


# source://console//lib/console/event/generic.rb#6
module Console
  extend ::Console::Interface
end

# source://console//lib/console/clock.rb#7
module Console::Clock
  class << self
    # source://console//lib/console/clock.rb#8
    def formatted_duration(duration); end

    # Get the current elapsed monotonic time.
    #
    # source://console//lib/console/clock.rb#31
    def now; end
  end
end

# source://console//lib/console/event/generic.rb#7
module Console::Event; end

# Represents a failure event.
#
# ```ruby
# Console::Event::Failure.for(exception).emit(self)
# ```
#
# source://console//lib/console/event/failure.rb#17
class Console::Event::Failure < ::Console::Event::Generic
  # @return [Failure] a new instance of Failure
  #
  # source://console//lib/console/event/failure.rb#34
  def initialize(exception, root = T.unsafe(nil)); end

  # source://console//lib/console/event/failure.rb#47
  def emit(*arguments, **options); end

  # Returns the value of attribute exception.
  #
  # source://console//lib/console/event/failure.rb#32
  def exception; end

  # source://console//lib/console/event/failure.rb#39
  def to_hash; end

  private

  # source://console//lib/console/event/failure.rb#55
  def extract(exception, hash); end

  class << self
    # source://console//lib/console/event/failure.rb#18
    def default_root; end

    # source://console//lib/console/event/failure.rb#24
    def for(exception); end

    # source://console//lib/console/event/failure.rb#28
    def log(subject, exception, **options); end
  end
end

# source://console//lib/console/event/generic.rb#8
class Console::Event::Generic
  # source://console//lib/console/event/generic.rb#9
  def as_json(*_arg0, **_arg1, &_arg2); end

  # source://console//lib/console/event/generic.rb#21
  def emit(*arguments, **options); end

  # source://console//lib/console/event/generic.rb#13
  def to_json(*_arg0, **_arg1, &_arg2); end

  # source://console//lib/console/event/generic.rb#17
  def to_s; end
end

# Represents a spawn event.
#
# ```ruby
# Console.info(self, **Console::Event::Spawn.for("ls", "-l"))
#
# event = Console::Event::Spawn.for("ls", "-l")
# event.status = Process.wait
# ```
#
# source://console//lib/console/event/spawn.rb#19
class Console::Event::Spawn < ::Console::Event::Generic
  # @return [Spawn] a new instance of Spawn
  #
  # source://console//lib/console/event/spawn.rb#30
  def initialize(environment, arguments, options); end

  # source://console//lib/console/event/spawn.rb#41
  def duration; end

  # source://console//lib/console/event/spawn.rb#62
  def emit(*arguments, **options); end

  # source://console//lib/console/event/spawn.rb#67
  def status=(status); end

  # source://console//lib/console/event/spawn.rb#47
  def to_hash; end

  class << self
    # source://console//lib/console/event/spawn.rb#20
    def for(*arguments, **options); end
  end
end

# source://console//lib/console/filter.rb#12
class Console::Filter
  # @return [Filter] a new instance of Filter
  #
  # source://console//lib/console/filter.rb#55
  def initialize(output, verbose: T.unsafe(nil), level: T.unsafe(nil), **options); end

  # source://console//lib/console/filter.rb#98
  def all!; end

  # source://console//lib/console/filter.rb#146
  def call(subject, *arguments, **options, &block); end

  # Clear any specific filters for the given class.
  #
  # source://console//lib/console/filter.rb#138
  def clear(subject); end

  # source://console//lib/console/filter.rb#131
  def disable(subject); end

  # Enable specific log level for the given class.
  #
  # source://console//lib/console/filter.rb#126
  def enable(subject, level = T.unsafe(nil)); end

  # You can enable and disable logging for classes. This function checks if logging for a given subject is enabled.
  #
  # @param subject [Object] the subject to check.
  # @return [Boolean]
  #
  # source://console//lib/console/filter.rb#112
  def enabled?(subject, level = T.unsafe(nil)); end

  # source://console//lib/console/filter.rb#102
  def filter(subject, level); end

  # Returns the value of attribute level.
  #
  # source://console//lib/console/filter.rb#75
  def level; end

  # source://console//lib/console/filter.rb#81
  def level=(level); end

  # source://console//lib/console/filter.rb#94
  def off!; end

  # Returns the value of attribute options.
  #
  # source://console//lib/console/filter.rb#79
  def options; end

  # Sets the attribute options
  #
  # @param value the value to set the attribute options to.
  #
  # source://console//lib/console/filter.rb#79
  def options=(_arg0); end

  # Returns the value of attribute output.
  #
  # source://console//lib/console/filter.rb#73
  def output; end

  # Sets the attribute output
  #
  # @param value the value to set the attribute output to.
  #
  # source://console//lib/console/filter.rb#73
  def output=(_arg0); end

  # Returns the value of attribute subjects.
  #
  # source://console//lib/console/filter.rb#77
  def subjects; end

  # Returns the value of attribute verbose.
  #
  # source://console//lib/console/filter.rb#74
  def verbose; end

  # source://console//lib/console/filter.rb#89
  def verbose!(value = T.unsafe(nil)); end

  # source://console//lib/console/filter.rb#65
  def with(level: T.unsafe(nil), verbose: T.unsafe(nil), **options); end

  class << self
    # source://console//lib/console/filter.rb#24
    def [](**levels); end

    # source://console//lib/console/filter.rb#14
    def define_immutable_method(name, &block); end
  end
end

# source://console//lib/console/format/safe.rb#9
module Console::Format
  class << self
    # source://console//lib/console/format.rb#10
    def default; end
  end
end

# This class is used to safely dump objects.
# It will attempt to dump the object using the given format, but if it fails, it will generate a safe version of the object.
#
# source://console//lib/console/format/safe.rb#12
class Console::Format::Safe
  # @return [Safe] a new instance of Safe
  #
  # source://console//lib/console/format/safe.rb#13
  def initialize(format: T.unsafe(nil), limit: T.unsafe(nil), encoding: T.unsafe(nil)); end

  # source://console//lib/console/format/safe.rb#19
  def dump(object); end

  private

  # source://console//lib/console/format/safe.rb#88
  def default_objects; end

  # source://console//lib/console/format/safe.rb#27
  def filter_backtrace(error); end

  # source://console//lib/console/format/safe.rb#77
  def replacement_for(object); end

  # source://console//lib/console/format/safe.rb#64
  def safe_dump(object, error); end

  # This will recursively generate a safe version of the object.
  # Nested hashes and arrays will be transformed recursively.
  # Strings will be encoded with the given encoding.
  # Primitive values will be returned as-is.
  # Other values will be converted using `as_json` if available, otherwise `to_s`.
  #
  # source://console//lib/console/format/safe.rb#97
  def safe_dump_recurse(object, limit = T.unsafe(nil), objects = T.unsafe(nil)); end
end

# The public logger interface.
#
# source://console//lib/console/interface.rb#10
module Console::Interface
  # Emit a log message with arbitrary arguments and options.
  #
  # source://console//lib/console/interface.rb#49
  def call(*_arg0, **_arg1, &_arg2); end

  # Emit a debug log message.
  #
  # source://console//lib/console/interface.rb#24
  def debug(*_arg0, **_arg1, &_arg2); end

  # Emit an error log message.
  #
  # source://console//lib/console/interface.rb#39
  def error(*_arg0, **_arg1, &_arg2); end

  # Emit a fatal log message.
  #
  # source://console//lib/console/interface.rb#44
  def fatal(*_arg0, **_arg1, &_arg2); end

  # Emit an informational log message.
  #
  # source://console//lib/console/interface.rb#29
  def info(*_arg0, **_arg1, &_arg2); end

  # Get the current logger instance.
  #
  # source://console//lib/console/interface.rb#12
  def logger; end

  # Set the current logger instance.
  #
  # The current logger instance is assigned per-fiber.
  #
  # source://console//lib/console/interface.rb#19
  def logger=(instance); end

  # Emit a warning log message.
  #
  # source://console//lib/console/interface.rb#34
  def warn(*_arg0, **_arg1, &_arg2); end
end

# source://console//lib/console/logger.rb#19
class Console::Logger < ::Console::Filter
  extend ::Fiber::Local

  # @return [Logger] a new instance of Logger
  #
  # source://console//lib/console/logger.rb#66
  def initialize(output, **options); end

  # source://console//lib/console/logger.rb#73
  def progress(subject, total, **options); end

  class << self
    # Set the default log level based on `$DEBUG` and `$VERBOSE`.
    # You can also specify CONSOLE_LEVEL=debug or CONSOLE_LEVEL=info in environment.
    # https://mislav.net/2011/06/ruby-verbose-mode/ has more details about how it all fits together.
    #
    # source://console//lib/console/logger.rb#25
    def default_log_level(env = T.unsafe(nil)); end

    # source://console//lib/console/logger.rb#42
    def default_logger(output = T.unsafe(nil), env = T.unsafe(nil), **options); end

    # source://fiber-local/1.1.0/lib/fiber/local.rb#16
    def fiber_local_attribute_name; end

    # source://console//lib/console/logger.rb#60
    def local; end

    # Controls verbose output using `$VERBOSE`.
    #
    # @return [Boolean]
    #
    # source://console//lib/console/logger.rb#38
    def verbose?(env = T.unsafe(nil)); end
  end
end

# source://console//lib/console/logger.rb#64
Console::Logger::DEFAULT_LEVEL = T.let(T.unsafe(nil), Integer)

# source://console//lib/console/output/terminal.rb#16
module Console::Output
  class << self
    # source://console//lib/console/output.rb#13
    def new(output = T.unsafe(nil), env = T.unsafe(nil), **options); end
  end
end

# source://console//lib/console/output/default.rb#12
module Console::Output::Default
  class << self
    # source://console//lib/console/output/default.rb#13
    def new(output, **options); end
  end
end

# A wrapper for outputting failure messages, which can include exceptions.
#
# source://console//lib/console/output/failure.rb#12
class Console::Output::Failure < ::Console::Output::Wrapper
  # @return [Failure] a new instance of Failure
  #
  # source://console//lib/console/output/failure.rb#13
  def initialize(output, **options); end

  # The exception must be either the last argument or passed as an option.
  #
  # source://console//lib/console/output/failure.rb#18
  def call(subject = T.unsafe(nil), *arguments, exception: T.unsafe(nil), **options, &block); end
end

# source://console//lib/console/output/serialized.rb#75
Console::Output::JSON = Console::Output::Serialized

# source://console//lib/console/output/null.rb#8
class Console::Output::Null
  # @return [Null] a new instance of Null
  #
  # source://console//lib/console/output/null.rb#9
  def initialize(*_arg0, **_arg1, &_arg2); end

  # source://console//lib/console/output/null.rb#16
  def call(*_arg0, **_arg1, &_arg2); end

  # source://console//lib/console/output/null.rb#12
  def last_output; end
end

# source://console//lib/console/output/serialized.rb#12
class Console::Output::Serialized
  # @return [Serialized] a new instance of Serialized
  #
  # source://console//lib/console/output/serialized.rb#13
  def initialize(io, format: T.unsafe(nil), **options); end

  # source://console//lib/console/output/serialized.rb#30
  def call(subject = T.unsafe(nil), *arguments, severity: T.unsafe(nil), **options, &block); end

  # source://console//lib/console/output/serialized.rb#26
  def dump(record); end

  # Returns the value of attribute format.
  #
  # source://console//lib/console/output/serialized.rb#24
  def format; end

  # Returns the value of attribute io.
  #
  # source://console//lib/console/output/serialized.rb#23
  def io; end

  # This a final output that then writes to an IO object.
  #
  # source://console//lib/console/output/serialized.rb#19
  def last_output; end
end

# source://console//lib/console/output/terminal.rb#17
class Console::Output::Terminal
  # @return [Terminal] a new instance of Terminal
  #
  # source://console//lib/console/output/terminal.rb#54
  def initialize(output, verbose: T.unsafe(nil), start_at: T.unsafe(nil), format: T.unsafe(nil), **options); end

  # source://console//lib/console/output/terminal.rb#106
  def call(subject = T.unsafe(nil), *arguments, name: T.unsafe(nil), severity: T.unsafe(nil), event: T.unsafe(nil), **options, &block); end

  # Returns the value of attribute io.
  #
  # source://console//lib/console/output/terminal.rb#86
  def io; end

  # This a final output that then writes to an IO object.
  #
  # source://console//lib/console/output/terminal.rb#82
  def last_output; end

  # source://console//lib/console/output/terminal.rb#97
  def register_formatters(namespace = T.unsafe(nil)); end

  # Returns the value of attribute start.
  #
  # source://console//lib/console/output/terminal.rb#90
  def start; end

  # Returns the value of attribute terminal.
  #
  # source://console//lib/console/output/terminal.rb#91
  def terminal; end

  # Returns the value of attribute verbose.
  #
  # source://console//lib/console/output/terminal.rb#88
  def verbose; end

  # source://console//lib/console/output/terminal.rb#93
  def verbose!(value = T.unsafe(nil)); end

  # Sets the attribute verbose
  #
  # @param value the value to set the attribute verbose to.
  #
  # source://console//lib/console/output/terminal.rb#88
  def verbose=(_arg0); end

  protected

  # source://console//lib/console/output/terminal.rb#236
  def build_prefix(name); end

  # source://console//lib/console/output/terminal.rb#173
  def default_suffix(object = T.unsafe(nil)); end

  # source://console//lib/console/output/terminal.rb#157
  def format_argument(argument, output); end

  # source://console//lib/console/output/terminal.rb#142
  def format_event(event, buffer, width); end

  # source://console//lib/console/output/terminal.rb#199
  def format_object_subject(severity, prefix, subject, output); end

  # source://console//lib/console/output/terminal.rb#153
  def format_options(options, output); end

  # source://console//lib/console/output/terminal.rb#211
  def format_string_subject(severity, prefix, subject, output); end

  # source://console//lib/console/output/terminal.rb#163
  def format_subject(severity, prefix, subject, buffer); end

  # source://console//lib/console/output/terminal.rb#223
  def format_value(value, output); end

  # source://console//lib/console/output/terminal.rb#232
  def time_offset_prefix; end

  class << self
    # Exports CONSOLE_START which can be used to synchronize the start times of all child processes when they log using delta time.
    #
    # source://console//lib/console/output/terminal.rb#41
    def start_at!(environment = T.unsafe(nil)); end
  end
end

# source://console//lib/console/output/terminal.rb#18
class Console::Output::Terminal::Buffer < ::StringIO
  # @return [Buffer] a new instance of Buffer
  #
  # source://console//lib/console/output/terminal.rb#19
  def initialize(prefix = T.unsafe(nil)); end

  # source://console//lib/console/output/terminal.rb#27
  def <<(*args, prefix: T.unsafe(nil)); end

  # Returns the value of attribute prefix.
  #
  # source://console//lib/console/output/terminal.rb#25
  def prefix; end

  # source://console//lib/console/output/terminal.rb#27
  def puts(*args, prefix: T.unsafe(nil)); end
end

# This, and all related methods, is considered private.
#
# source://console//lib/console/output/terminal.rb#38
Console::Output::Terminal::CONSOLE_START_AT = T.let(T.unsafe(nil), String)

# source://console//lib/console/output/terminal.rb#104
Console::Output::Terminal::UNKNOWN = T.let(T.unsafe(nil), Symbol)

# source://console//lib/console/output/terminal.rb#245
module Console::Output::Text
  class << self
    # source://console//lib/console/output/terminal.rb#246
    def new(output, **options); end
  end
end

# source://console//lib/console/output/wrapper.rb#8
class Console::Output::Wrapper
  # @return [Wrapper] a new instance of Wrapper
  #
  # source://console//lib/console/output/wrapper.rb#9
  def initialize(delegate, **options); end

  # source://console//lib/console/output/wrapper.rb#23
  def call(*_arg0, **_arg1, &_arg2); end

  # Returns the value of attribute delegate.
  #
  # source://console//lib/console/output/wrapper.rb#13
  def delegate; end

  # source://console//lib/console/output/wrapper.rb#15
  def last_output; end

  # source://console//lib/console/output/wrapper.rb#19
  def verbose!(value = T.unsafe(nil)); end
end

# source://console//lib/console/output/terminal.rb#251
module Console::Output::XTerm
  class << self
    # source://console//lib/console/output/terminal.rb#252
    def new(output, **options); end
  end
end

# source://console//lib/console/progress.rb#10
class Console::Progress
  # @return [Progress] a new instance of Progress
  #
  # source://console//lib/console/progress.rb#15
  def initialize(subject, total = T.unsafe(nil), minimum_output_duration: T.unsafe(nil), **options); end

  # source://console//lib/console/progress.rb#44
  def average_duration; end

  # Returns the value of attribute current.
  #
  # source://console//lib/console/progress.rb#29
  def current; end

  # source://console//lib/console/progress.rb#32
  def duration; end

  # source://console//lib/console/progress.rb#50
  def estimated_remaining_time; end

  # source://console//lib/console/progress.rb#67
  def increment(amount = T.unsafe(nil)); end

  # source://console//lib/console/progress.rb#87
  def mark(*arguments, **options); end

  # source://console//lib/console/progress.rb#36
  def ratio; end

  # source://console//lib/console/progress.rb#40
  def remaining; end

  # source://console//lib/console/progress.rb#78
  def resize(total); end

  # Returns the value of attribute subject.
  #
  # source://console//lib/console/progress.rb#28
  def subject; end

  # source://console//lib/console/progress.rb#56
  def to_hash; end

  # source://console//lib/console/progress.rb#91
  def to_s; end

  # Returns the value of attribute total.
  #
  # source://console//lib/console/progress.rb#30
  def total; end

  private

  # source://console//lib/console/progress.rb#101
  def duration_since_last_output; end

  # @return [Boolean]
  #
  # source://console//lib/console/progress.rb#107
  def output?; end

  class << self
    # source://console//lib/console/progress.rb#11
    def now; end
  end
end

# source://console//lib/console/resolver.rb#10
class Console::Resolver
  # @return [Resolver] a new instance of Resolver
  #
  # source://console//lib/console/resolver.rb#62
  def initialize; end

  # source://console//lib/console/resolver.rb#68
  def bind(names, &block); end

  # source://console//lib/console/resolver.rb#88
  def resolve(trace_point); end

  # @return [Boolean]
  #
  # source://console//lib/console/resolver.rb#84
  def waiting?; end

  class << self
    # You can change the log level for different classes using CONSOLE_$LEVEL env vars.
    #
    # e.g. `CONSOLE_WARN=Acorn,Banana CONSOLE_DEBUG=Cat` will set the log level for the classes Acorn and Banana to `warn` and Cat to `debug`. This overrides the default log level.
    #
    # You can enable all log levels for a given class by using `CONSOLE_ON=MyClass`. Similarly you can disable all logging using `CONSOLE_OFF=MyClass`.
    #
    # source://console//lib/console/resolver.rb#22
    def default_resolver(logger, env = T.unsafe(nil)); end
  end
end

# Styled terminal output.
#
# source://console//lib/console/terminal/text.rb#10
module Console::Terminal
  class << self
    # source://console//lib/console/terminal.rb#15
    def for(io); end
  end
end

# source://console//lib/console/terminal/formatter/progress.rb#8
module Console::Terminal::Formatter; end

# source://console//lib/console/terminal/formatter/failure.rb#9
class Console::Terminal::Formatter::Failure
  # @return [Failure] a new instance of Failure
  #
  # source://console//lib/console/terminal/formatter/failure.rb#12
  def initialize(terminal); end

  # source://console//lib/console/terminal/formatter/failure.rb#22
  def format(event, output, prefix: T.unsafe(nil), verbose: T.unsafe(nil), width: T.unsafe(nil)); end
end

# source://console//lib/console/terminal/formatter/failure.rb#10
Console::Terminal::Formatter::Failure::KEY = T.let(T.unsafe(nil), Symbol)

# source://console//lib/console/terminal/formatter/progress.rb#9
class Console::Terminal::Formatter::Progress
  # @return [Progress] a new instance of Progress
  #
  # source://console//lib/console/terminal/formatter/progress.rb#24
  def initialize(terminal); end

  # source://console//lib/console/terminal/formatter/progress.rb#29
  def format(event, output, verbose: T.unsafe(nil), width: T.unsafe(nil)); end

  private

  # source://console//lib/console/terminal/formatter/progress.rb#44
  def bar(value, width); end
end

# source://console//lib/console/terminal/formatter/progress.rb#12
Console::Terminal::Formatter::Progress::BLOCK = T.let(T.unsafe(nil), Array)

# source://console//lib/console/terminal/formatter/progress.rb#10
Console::Terminal::Formatter::Progress::KEY = T.let(T.unsafe(nil), Symbol)

# Format spawn events.
#
# source://console//lib/console/terminal/formatter/spawn.rb#10
class Console::Terminal::Formatter::Spawn
  # @return [Spawn] a new instance of Spawn
  #
  # source://console//lib/console/terminal/formatter/spawn.rb#13
  def initialize(terminal); end

  # source://console//lib/console/terminal/formatter/spawn.rb#18
  def format(event, output, verbose: T.unsafe(nil), width: T.unsafe(nil)); end

  private

  # source://console//lib/console/terminal/formatter/spawn.rb#34
  def chdir_string(options); end
end

# source://console//lib/console/terminal/formatter/spawn.rb#11
Console::Terminal::Formatter::Spawn::KEY = T.let(T.unsafe(nil), Symbol)

# source://console//lib/console/terminal/text.rb#11
class Console::Terminal::Text
  # @return [Text] a new instance of Text
  #
  # source://console//lib/console/terminal/text.rb#12
  def initialize(output); end

  # source://console//lib/console/terminal/text.rb#17
  def [](key); end

  # source://console//lib/console/terminal/text.rb#21
  def []=(key, value); end

  # @return [Boolean]
  #
  # source://console//lib/console/terminal/text.rb#25
  def colors?; end

  # Print out the given arguments.
  # When the argument is a symbol, look up the style and inject it into the output stream.
  # When the argument is a proc/lambda, call it with self as the argument.
  # When the argument is anything else, write it directly to the output.
  #
  # source://console//lib/console/terminal/text.rb#63
  def print(*arguments); end

  # Print out the arguments as per {#print}, followed by the reset sequence and a newline.
  #
  # source://console//lib/console/terminal/text.rb#77
  def print_line(*arguments); end

  # source://console//lib/console/terminal/text.rb#49
  def puts(*arguments, style: T.unsafe(nil)); end

  # source://console//lib/console/terminal/text.rb#36
  def reset; end

  # source://console//lib/console/terminal/text.rb#33
  def style(foreground, background = T.unsafe(nil), *attributes); end

  # source://console//lib/console/terminal/text.rb#29
  def width; end

  # source://console//lib/console/terminal/text.rb#39
  def write(*arguments, style: T.unsafe(nil)); end
end

# source://console//lib/console/terminal/xterm.rb#13
class Console::Terminal::XTerm < ::Console::Terminal::Text
  # @return [Boolean]
  #
  # source://console//lib/console/terminal/xterm.rb#38
  def colors?; end

  # source://console//lib/console/terminal/xterm.rb#71
  def reset; end

  # source://console//lib/console/terminal/xterm.rb#42
  def size; end

  # source://console//lib/console/terminal/xterm.rb#53
  def style(foreground, background = T.unsafe(nil), *attributes); end

  # source://console//lib/console/terminal/xterm.rb#49
  def width; end
end

# source://console//lib/console/terminal/xterm.rb#26
Console::Terminal::XTerm::ATTRIBUTES = T.let(T.unsafe(nil), Hash)

# source://console//lib/console/terminal/xterm.rb#14
Console::Terminal::XTerm::COLORS = T.let(T.unsafe(nil), Hash)

# source://console//lib/console/filter.rb#10
Console::UNKNOWN = T.let(T.unsafe(nil), Symbol)

# source://console//lib/console/version.rb#7
Console::VERSION = T.let(T.unsafe(nil), String)
