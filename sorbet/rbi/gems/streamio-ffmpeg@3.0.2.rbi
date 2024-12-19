# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `streamio-ffmpeg` gem.
# Please instead update this file by running `bin/tapioca gem streamio-ffmpeg`.


# source://streamio-ffmpeg//lib/ffmpeg/version.rb#1
module FFMPEG
  class << self
    # Get the path to the ffmpeg binary, defaulting to 'ffmpeg'
    #
    # @raise Errno::ENOENT if the ffmpeg binary cannot be found
    # @return [String] the path to the ffmpeg binary
    #
    # source://streamio-ffmpeg//lib/streamio-ffmpeg.rb#50
    def ffmpeg_binary; end

    # Set the path of the ffmpeg binary.
    # Can be useful if you need to specify a path such as /usr/local/bin/ffmpeg
    #
    # @param path [String] to the ffmpeg binary
    # @raise Errno::ENOENT if the ffmpeg binary cannot be found
    # @return [String] the path you set
    #
    # source://streamio-ffmpeg//lib/streamio-ffmpeg.rb#39
    def ffmpeg_binary=(bin); end

    # Get the path to the ffprobe binary, defaulting to what is on ENV['PATH']
    #
    # @raise Errno::ENOENT if the ffprobe binary cannot be found
    # @return [String] the path to the ffprobe binary
    #
    # source://streamio-ffmpeg//lib/streamio-ffmpeg.rb#58
    def ffprobe_binary; end

    # Set the path of the ffprobe binary.
    # Can be useful if you need to specify a path such as /usr/local/bin/ffprobe
    #
    # @param path [String] to the ffprobe binary
    # @raise Errno::ENOENT if the ffprobe binary cannot be found
    # @return [String] the path you set
    #
    # source://streamio-ffmpeg//lib/streamio-ffmpeg.rb#68
    def ffprobe_binary=(bin); end

    # Get FFMPEG logger.
    #
    # @return [Logger]
    #
    # source://streamio-ffmpeg//lib/streamio-ffmpeg.rb#26
    def logger; end

    # FFMPEG logs information about its progress when it's transcoding.
    # Jack in your own logger through this method if you wish to.
    #
    # @param log [Logger] your own logger
    # @return [Logger] the logger you set
    #
    # source://streamio-ffmpeg//lib/streamio-ffmpeg.rb#19
    def logger=(log); end

    # Get the maximum number of http redirect attempts
    #
    # @return [Integer] the maximum number of retries
    #
    # source://streamio-ffmpeg//lib/streamio-ffmpeg.rb#78
    def max_http_redirect_attempts; end

    # Set the maximum number of http redirect attempts.
    #
    # @param the [Integer] maximum number of retries
    # @raise Errno::ENOENT if the value is negative or not an Integer
    # @return [Integer] the number of retries you set
    #
    # source://streamio-ffmpeg//lib/streamio-ffmpeg.rb#87
    def max_http_redirect_attempts=(v); end

    # Cross-platform way of finding an executable in the $PATH.
    #
    #   which('ruby') #=> /usr/bin/ruby
    # see: http://stackoverflow.com/questions/2108727/which-in-ruby-checking-if-program-exists-in-path-from-ruby
    #
    # @raise [Errno::ENOENT]
    #
    # source://streamio-ffmpeg//lib/streamio-ffmpeg.rb#97
    def which(cmd); end
  end
end

# source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#2
class FFMPEG::EncodingOptions < ::Hash
  # @return [EncodingOptions] a new instance of EncodingOptions
  #
  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#3
  def initialize(options = T.unsafe(nil)); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#41
  def height; end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#7
  def params_order(k); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#21
  def to_a; end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#37
  def width; end

  private

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#55
  def calculate_aspect; end

  # @return [Boolean]
  #
  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#60
  def calculate_aspect?; end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#51
  def convert_aspect(value); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#84
  def convert_audio_bitrate(value); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#92
  def convert_audio_channels(value); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#80
  def convert_audio_codec(value); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#128
  def convert_audio_preset(value); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#88
  def convert_audio_sample_rate(value); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#104
  def convert_buffer_size(value); end

  # @raise [ArgumentError]
  #
  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#191
  def convert_custom(value); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#120
  def convert_duration(value); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#132
  def convert_file_preset(value); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#68
  def convert_frame_rate(value); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#136
  def convert_keyframe_interval(value); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#155
  def convert_quality(value); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#72
  def convert_resolution(value); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#144
  def convert_screenshot(value); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#140
  def convert_seek_time(value); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#116
  def convert_target(value); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#112
  def convert_threads(value); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#159
  def convert_vframes(value); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#76
  def convert_video_bitrate(value); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#108
  def convert_video_bitrate_tolerance(value); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#64
  def convert_video_codec(value); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#96
  def convert_video_max_bitrate(value); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#100
  def convert_video_min_bitrate(value); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#124
  def convert_video_preset(value); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#171
  def convert_watermark(value); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#175
  def convert_watermark_filter(value); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#167
  def convert_x264_preset(value); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#163
  def convert_x264_vprofile(value); end

  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#196
  def k_format(value); end

  # @return [Boolean]
  #
  # source://streamio-ffmpeg//lib/ffmpeg/encoding_options.rb#46
  def supports_option?(option); end
end

# source://streamio-ffmpeg//lib/ffmpeg/errors.rb#2
class FFMPEG::Error < ::StandardError; end

# source://streamio-ffmpeg//lib/ffmpeg/errors.rb#4
class FFMPEG::HTTPTooManyRequests < ::StandardError; end

# source://streamio-ffmpeg//lib/ffmpeg/movie.rb#6
class FFMPEG::Movie
  # @return [Movie] a new instance of Movie
  #
  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#15
  def initialize(path); end

  # Returns the value of attribute audio_bitrate.
  #
  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#9
  def audio_bitrate; end

  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#185
  def audio_channel_layout; end

  # Returns the value of attribute audio_channels.
  #
  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#9
  def audio_channels; end

  # Returns the value of attribute audio_codec.
  #
  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#9
  def audio_codec; end

  # Returns the value of attribute audio_sample_rate.
  #
  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#9
  def audio_sample_rate; end

  # Returns the value of attribute audio_stream.
  #
  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#9
  def audio_stream; end

  # Returns the value of attribute audio_streams.
  #
  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#9
  def audio_streams; end

  # Returns the value of attribute audio_tags.
  #
  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#9
  def audio_tags; end

  # Returns the value of attribute bitrate.
  #
  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#7
  def bitrate; end

  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#169
  def calculated_aspect_ratio; end

  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#173
  def calculated_pixel_aspect_ratio; end

  # Returns the value of attribute colorspace.
  #
  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#8
  def colorspace; end

  # Returns the value of attribute container.
  #
  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#10
  def container; end

  # Returns the value of attribute creation_time.
  #
  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#7
  def creation_time; end

  # Returns the value of attribute dar.
  #
  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#8
  def dar; end

  # Returns the value of attribute duration.
  #
  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#7
  def duration; end

  # Returns the value of attribute format_tags.
  #
  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#11
  def format_tags; end

  # Returns the value of attribute frame_rate.
  #
  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#8
  def frame_rate; end

  # Returns the value of attribute height.
  #
  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#159
  def height; end

  # @return [Boolean]
  #
  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#151
  def local?; end

  # Returns the value of attribute metadata.
  #
  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#11
  def metadata; end

  # Returns the value of attribute path.
  #
  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#7
  def path; end

  # @return [Boolean]
  #
  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#147
  def remote?; end

  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#163
  def resolution; end

  # Returns the value of attribute rotation.
  #
  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#7
  def rotation; end

  # Returns the value of attribute sar.
  #
  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#8
  def sar; end

  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#203
  def screenshot(output_file, options = T.unsafe(nil), transcoder_options = T.unsafe(nil), &block); end

  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#177
  def size; end

  # Returns the value of attribute time.
  #
  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#7
  def time; end

  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#199
  def transcode(output_file, options = T.unsafe(nil), transcoder_options = T.unsafe(nil), &block); end

  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#134
  def unsupported_streams(std_error); end

  # @return [Boolean]
  #
  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#143
  def valid?; end

  # Returns the value of attribute video_bitrate.
  #
  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#8
  def video_bitrate; end

  # Returns the value of attribute video_codec.
  #
  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#8
  def video_codec; end

  # Returns the value of attribute video_stream.
  #
  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#8
  def video_stream; end

  # Returns the value of attribute width.
  #
  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#155
  def width; end

  protected

  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#208
  def aspect_from_dar; end

  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#223
  def aspect_from_dimensions; end

  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#212
  def aspect_from_sar; end

  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#216
  def calculate_aspect(ratio); end

  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#228
  def fix_encoding(output); end

  # source://streamio-ffmpeg//lib/ffmpeg/movie.rb#234
  def head(location = T.unsafe(nil), limit = T.unsafe(nil)); end
end

# source://streamio-ffmpeg//lib/ffmpeg/movie.rb#13
FFMPEG::Movie::UNSUPPORTED_CODEC_PATTERN = T.let(T.unsafe(nil), Regexp)

# source://streamio-ffmpeg//lib/ffmpeg/transcoder.rb#4
class FFMPEG::Transcoder
  # @return [Transcoder] a new instance of Transcoder
  #
  # source://streamio-ffmpeg//lib/ffmpeg/transcoder.rb#13
  def initialize(input, output_file, options = T.unsafe(nil), transcoder_options = T.unsafe(nil)); end

  # Returns the value of attribute command.
  #
  # source://streamio-ffmpeg//lib/ffmpeg/transcoder.rb#5
  def command; end

  # source://streamio-ffmpeg//lib/ffmpeg/transcoder.rb#58
  def encoded; end

  # @return [Boolean]
  #
  # source://streamio-ffmpeg//lib/ffmpeg/transcoder.rb#52
  def encoding_succeeded?; end

  # Returns the value of attribute input.
  #
  # source://streamio-ffmpeg//lib/ffmpeg/transcoder.rb#5
  def input; end

  # source://streamio-ffmpeg//lib/ffmpeg/transcoder.rb#42
  def run(&block); end

  # source://streamio-ffmpeg//lib/ffmpeg/transcoder.rb#62
  def timeout; end

  private

  # source://streamio-ffmpeg//lib/ffmpeg/transcoder.rb#116
  def apply_transcoder_options; end

  # source://streamio-ffmpeg//lib/ffmpeg/transcoder.rb#135
  def fix_encoding(output); end

  # frame= 4855 fps= 46 q=31.0 size=   45306kB time=00:02:42.28 bitrate=2287.0kbits/
  #
  # source://streamio-ffmpeg//lib/ffmpeg/transcoder.rb#68
  def transcode_movie; end

  # source://streamio-ffmpeg//lib/ffmpeg/transcoder.rb#105
  def validate_output_file(&block); end

  class << self
    # Returns the value of attribute timeout.
    #
    # source://streamio-ffmpeg//lib/ffmpeg/transcoder.rb#10
    def timeout; end

    # Sets the attribute timeout
    #
    # @param value the value to set the attribute timeout to.
    #
    # source://streamio-ffmpeg//lib/ffmpeg/transcoder.rb#10
    def timeout=(_arg0); end
  end
end

# source://streamio-ffmpeg//lib/ffmpeg/version.rb#2
FFMPEG::VERSION = T.let(T.unsafe(nil), String)

# Monkey Patch timeout support into the IO class
#
# source://streamio-ffmpeg//lib/ffmpeg/io_monkey.rb#14
class IO
  include ::Enumerable
  include ::File::Constants

  # source://streamio-ffmpeg//lib/ffmpeg/io_monkey.rb#15
  def each_with_timeout(pid, seconds, sep_string = T.unsafe(nil)); end
end

class IO::Buffer
  include ::Comparable

  def initialize(*_arg0); end

  def &(_arg0); end
  def <=>(_arg0); end
  def ^(_arg0); end
  def and!(_arg0); end
  def clear(*_arg0); end
  def copy(*_arg0); end
  def each(*_arg0); end
  def each_byte(*_arg0); end
  def empty?; end
  def external?; end
  def free; end
  def get_string(*_arg0); end
  def get_value(_arg0, _arg1); end
  def get_values(_arg0, _arg1); end
  def hexdump(*_arg0); end
  def inspect; end
  def internal?; end
  def locked; end
  def locked?; end
  def mapped?; end
  def not!; end
  def null?; end
  def or!(_arg0); end
  def pread(*_arg0); end
  def private?; end
  def pwrite(*_arg0); end
  def read(*_arg0); end
  def readonly?; end
  def resize(_arg0); end
  def set_string(*_arg0); end
  def set_value(_arg0, _arg1, _arg2); end
  def set_values(_arg0, _arg1, _arg2); end
  def shared?; end
  def size; end
  def slice(*_arg0); end
  def to_s; end
  def transfer; end
  def valid?; end
  def values(*_arg0); end
  def write(*_arg0); end
  def xor!(_arg0); end
  def |(_arg0); end
  def ~; end

  private

  def initialize_copy(_arg0); end

  class << self
    def for(_arg0); end
    def map(*_arg0); end
    def size_of(_arg0); end
    def string(_arg0); end
  end
end

class IO::Buffer::AccessError < ::RuntimeError; end
class IO::Buffer::AllocationError < ::RuntimeError; end
IO::Buffer::BIG_ENDIAN = T.let(T.unsafe(nil), Integer)
IO::Buffer::DEFAULT_SIZE = T.let(T.unsafe(nil), Integer)
IO::Buffer::EXTERNAL = T.let(T.unsafe(nil), Integer)
IO::Buffer::HOST_ENDIAN = T.let(T.unsafe(nil), Integer)
IO::Buffer::INTERNAL = T.let(T.unsafe(nil), Integer)
class IO::Buffer::InvalidatedError < ::RuntimeError; end
IO::Buffer::LITTLE_ENDIAN = T.let(T.unsafe(nil), Integer)
IO::Buffer::LOCKED = T.let(T.unsafe(nil), Integer)
class IO::Buffer::LockedError < ::RuntimeError; end
IO::Buffer::MAPPED = T.let(T.unsafe(nil), Integer)
class IO::Buffer::MaskError < ::ArgumentError; end
IO::Buffer::NETWORK_ENDIAN = T.let(T.unsafe(nil), Integer)
IO::Buffer::PAGE_SIZE = T.let(T.unsafe(nil), Integer)
IO::Buffer::PRIVATE = T.let(T.unsafe(nil), Integer)
IO::Buffer::READONLY = T.let(T.unsafe(nil), Integer)
IO::Buffer::SHARED = T.let(T.unsafe(nil), Integer)

class IO::ConsoleMode
  def echo=(_arg0); end
  def raw(*_arg0); end
  def raw!(*_arg0); end

  private

  def initialize_copy(_arg0); end
end

class IO::EAGAINWaitReadable < ::Errno::EAGAIN
  include ::IO::WaitReadable
end

class IO::EAGAINWaitWritable < ::Errno::EAGAIN
  include ::IO::WaitWritable
end

class IO::EINPROGRESSWaitReadable < ::Errno::EINPROGRESS
  include ::IO::WaitReadable
end

class IO::EINPROGRESSWaitWritable < ::Errno::EINPROGRESS
  include ::IO::WaitWritable
end

IO::EWOULDBLOCKWaitReadable = IO::EAGAINWaitReadable
IO::EWOULDBLOCKWaitWritable = IO::EAGAINWaitWritable
IO::PRIORITY = T.let(T.unsafe(nil), Integer)
IO::READABLE = T.let(T.unsafe(nil), Integer)
class IO::TimeoutError < ::IOError; end
IO::WRITABLE = T.let(T.unsafe(nil), Integer)
