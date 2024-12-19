# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `terrapin` gem.
# Please instead update this file by running `bin/tapioca gem terrapin`.


# source://terrapin//lib/terrapin/os_detector.rb#3
module Terrapin; end

# source://terrapin//lib/terrapin/command_line.rb#4
class Terrapin::CommandLine
  # @return [CommandLine] a new instance of CommandLine
  #
  # source://terrapin//lib/terrapin/command_line.rb#51
  def initialize(binary, params = T.unsafe(nil), options = T.unsafe(nil)); end

  # source://terrapin//lib/terrapin/command_line.rb#63
  def command(interpolations = T.unsafe(nil)); end

  # source://terrapin//lib/terrapin/command_line.rb#100
  def command_error_output; end

  # source://terrapin//lib/terrapin/command_line.rb#96
  def command_output; end

  # Returns the value of attribute exit_status.
  #
  # source://terrapin//lib/terrapin/command_line.rb#49
  def exit_status; end

  # source://terrapin//lib/terrapin/command_line.rb#104
  def output; end

  # source://terrapin//lib/terrapin/command_line.rb#69
  def run(interpolations = T.unsafe(nil)); end

  # Returns the value of attribute runner.
  #
  # source://terrapin//lib/terrapin/command_line.rb#49
  def runner; end

  private

  # source://terrapin//lib/terrapin/command_line.rb#193
  def bit_bucket; end

  # source://terrapin//lib/terrapin/command_line.rb#110
  def colored(text, ansi_color = T.unsafe(nil)); end

  # source://terrapin//lib/terrapin/command_line.rb#150
  def environment; end

  # source://terrapin//lib/terrapin/command_line.rb#146
  def execute(command); end

  # source://terrapin//lib/terrapin/command_line.rb#158
  def interpolate(pattern, interpolations); end

  # source://terrapin//lib/terrapin/command_line.rb#118
  def log(text); end

  # source://terrapin//lib/terrapin/command_line.rb#130
  def os_path_prefix; end

  # source://terrapin//lib/terrapin/command_line.rb#124
  def path_prefix; end

  # source://terrapin//lib/terrapin/command_line.rb#154
  def runner_options; end

  # source://terrapin//lib/terrapin/command_line.rb#178
  def shell_quote(string); end

  # source://terrapin//lib/terrapin/command_line.rb#174
  def shell_quote_all_values(values); end

  # source://terrapin//lib/terrapin/command_line.rb#170
  def stringify_keys(hash); end

  # source://terrapin//lib/terrapin/command_line.rb#138
  def unix_path_prefix; end

  # source://terrapin//lib/terrapin/command_line.rb#142
  def windows_path_prefix; end

  class << self
    # source://terrapin//lib/terrapin/command_line.rb#18
    def environment; end

    # source://terrapin//lib/terrapin/command_line.rb#30
    def fake!; end

    # Returns the value of attribute logger.
    #
    # source://terrapin//lib/terrapin/command_line.rb#6
    def logger; end

    # Sets the attribute logger
    #
    # @param value the value to set the attribute logger to.
    #
    # source://terrapin//lib/terrapin/command_line.rb#6
    def logger=(_arg0); end

    # source://terrapin//lib/terrapin/command_line.rb#8
    def path; end

    # source://terrapin//lib/terrapin/command_line.rb#12
    def path=(supplemental_path); end

    # Returns the value of attribute runner.
    #
    # source://terrapin//lib/terrapin/command_line.rb#22
    def runner; end

    # Sets the attribute runner
    #
    # @param value the value to set the attribute runner to.
    #
    # source://terrapin//lib/terrapin/command_line.rb#6
    def runner=(_arg0); end

    # source://terrapin//lib/terrapin/command_line.rb#26
    def runner_options; end

    # source://terrapin//lib/terrapin/command_line.rb#34
    def unfake!; end

    private

    # source://terrapin//lib/terrapin/command_line.rb#40
    def best_runner; end
  end
end

# source://terrapin//lib/terrapin/command_line/runners/backticks_runner.rb#7
class Terrapin::CommandLine::BackticksRunner
  # source://terrapin//lib/terrapin/command_line/runners/backticks_runner.rb#16
  def call(command, env = T.unsafe(nil), options = T.unsafe(nil)); end

  # @return [Boolean]
  #
  # source://terrapin//lib/terrapin/command_line/runners/backticks_runner.rb#12
  def supported?; end

  private

  # source://terrapin//lib/terrapin/command_line/runners/backticks_runner.rb#24
  def with_modified_environment(env, &block); end

  class << self
    # @return [Boolean]
    #
    # source://terrapin//lib/terrapin/command_line/runners/backticks_runner.rb#8
    def supported?; end
  end
end

# source://terrapin//lib/terrapin/command_line/runners/fake_runner.rb#5
class Terrapin::CommandLine::FakeRunner
  # @return [FakeRunner] a new instance of FakeRunner
  #
  # source://terrapin//lib/terrapin/command_line/runners/fake_runner.rb#16
  def initialize; end

  # source://terrapin//lib/terrapin/command_line/runners/fake_runner.rb#20
  def call(command, env = T.unsafe(nil), options = T.unsafe(nil)); end

  # Returns the value of attribute commands.
  #
  # source://terrapin//lib/terrapin/command_line/runners/fake_runner.rb#14
  def commands; end

  # @return [Boolean]
  #
  # source://terrapin//lib/terrapin/command_line/runners/fake_runner.rb#25
  def ran?(predicate_command); end

  # @return [Boolean]
  #
  # source://terrapin//lib/terrapin/command_line/runners/fake_runner.rb#10
  def supported?; end

  class << self
    # @return [Boolean]
    #
    # source://terrapin//lib/terrapin/command_line/runners/fake_runner.rb#6
    def supported?; end
  end
end

# source://terrapin//lib/terrapin/command_line/multi_pipe.rb#3
class Terrapin::CommandLine::MultiPipe
  # @return [MultiPipe] a new instance of MultiPipe
  #
  # source://terrapin//lib/terrapin/command_line/multi_pipe.rb#4
  def initialize; end

  # source://terrapin//lib/terrapin/command_line/multi_pipe.rb#13
  def output; end

  # source://terrapin//lib/terrapin/command_line/multi_pipe.rb#9
  def pipe_options; end

  # source://terrapin//lib/terrapin/command_line/multi_pipe.rb#17
  def read_and_then(&block); end

  private

  # source://terrapin//lib/terrapin/command_line/multi_pipe.rb#36
  def close_read; end

  # source://terrapin//lib/terrapin/command_line/multi_pipe.rb#26
  def close_write; end

  # source://terrapin//lib/terrapin/command_line/multi_pipe.rb#31
  def read; end

  # source://terrapin//lib/terrapin/command_line/multi_pipe.rb#41
  def read_stream(io); end
end

# source://terrapin//lib/terrapin/command_line/output.rb#1
class Terrapin::CommandLine::Output
  # @return [Output] a new instance of Output
  #
  # source://terrapin//lib/terrapin/command_line/output.rb#2
  def initialize(output = T.unsafe(nil), error_output = T.unsafe(nil)); end

  # Returns the value of attribute error_output.
  #
  # source://terrapin//lib/terrapin/command_line/output.rb#7
  def error_output; end

  # Returns the value of attribute output.
  #
  # source://terrapin//lib/terrapin/command_line/output.rb#7
  def output; end

  # source://terrapin//lib/terrapin/command_line/output.rb#9
  def to_s; end
end

# source://terrapin//lib/terrapin/command_line/runners/popen_runner.rb#5
class Terrapin::CommandLine::PopenRunner
  # source://terrapin//lib/terrapin/command_line/runners/popen_runner.rb#14
  def call(command, env = T.unsafe(nil), options = T.unsafe(nil)); end

  # @return [Boolean]
  #
  # source://terrapin//lib/terrapin/command_line/runners/popen_runner.rb#10
  def supported?; end

  private

  # source://terrapin//lib/terrapin/command_line/runners/popen_runner.rb#24
  def with_modified_environment(env, &block); end

  class << self
    # @return [Boolean]
    #
    # source://terrapin//lib/terrapin/command_line/runners/popen_runner.rb#6
    def supported?; end
  end
end

# source://terrapin//lib/terrapin/command_line/runners/posix_runner.rb#5
class Terrapin::CommandLine::PosixRunner
  # source://terrapin//lib/terrapin/command_line/runners/posix_runner.rb#20
  def call(command, env = T.unsafe(nil), options = T.unsafe(nil)); end

  # @return [Boolean]
  #
  # source://terrapin//lib/terrapin/command_line/runners/posix_runner.rb#16
  def supported?; end

  private

  # source://terrapin//lib/terrapin/command_line/runners/posix_runner.rb#31
  def spawn(*args); end

  # source://terrapin//lib/terrapin/command_line/runners/posix_runner.rb#35
  def waitpid(pid); end

  class << self
    # @return [Boolean]
    #
    # source://terrapin//lib/terrapin/command_line/runners/posix_runner.rb#6
    def available?; end

    # @return [Boolean]
    #
    # source://terrapin//lib/terrapin/command_line/runners/posix_runner.rb#12
    def supported?; end

    private

    # @return [Boolean]
    #
    # source://terrapin//lib/terrapin/command_line/runners/posix_runner.rb#39
    def posix_spawn_gem_available?; end
  end
end

# source://terrapin//lib/terrapin/command_line/runners/process_runner.rb#5
class Terrapin::CommandLine::ProcessRunner
  # source://terrapin//lib/terrapin/command_line/runners/process_runner.rb#18
  def call(command, env = T.unsafe(nil), options = T.unsafe(nil)); end

  # @return [Boolean]
  #
  # source://terrapin//lib/terrapin/command_line/runners/process_runner.rb#14
  def supported?; end

  private

  # source://terrapin//lib/terrapin/command_line/runners/process_runner.rb#29
  def spawn(*args); end

  # source://terrapin//lib/terrapin/command_line/runners/process_runner.rb#33
  def waitpid(pid); end

  class << self
    # @return [Boolean]
    #
    # source://terrapin//lib/terrapin/command_line/runners/process_runner.rb#6
    def available?; end

    # @return [Boolean]
    #
    # source://terrapin//lib/terrapin/command_line/runners/process_runner.rb#10
    def supported?; end
  end
end

# source://terrapin//lib/terrapin/exceptions.rb#4
class Terrapin::CommandLineError < ::StandardError; end

# source://terrapin//lib/terrapin/exceptions.rb#5
class Terrapin::CommandNotFoundError < ::Terrapin::CommandLineError; end

# source://terrapin//lib/terrapin/exceptions.rb#6
class Terrapin::ExitStatusError < ::Terrapin::CommandLineError; end

# source://terrapin//lib/terrapin/exceptions.rb#7
class Terrapin::InterpolationError < ::Terrapin::CommandLineError; end

# source://terrapin//lib/terrapin/os_detector.rb#26
Terrapin::OS = T.let(T.unsafe(nil), Terrapin::OSDetector)

# source://terrapin//lib/terrapin/os_detector.rb#4
class Terrapin::OSDetector
  # source://terrapin//lib/terrapin/os_detector.rb#21
  def arch; end

  # @return [Boolean]
  #
  # source://terrapin//lib/terrapin/os_detector.rb#5
  def java?; end

  # source://terrapin//lib/terrapin/os_detector.rb#17
  def path_separator; end

  # @return [Boolean]
  #
  # source://terrapin//lib/terrapin/os_detector.rb#9
  def unix?; end

  # @return [Boolean]
  #
  # source://terrapin//lib/terrapin/os_detector.rb#13
  def windows?; end
end
