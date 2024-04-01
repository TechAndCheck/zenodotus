# typed: true

class YoutubeMediaSource < MediaSource
  attr_reader(:url, :invalid_url)

  # Limit all urls to the host below
  #
  # @return [String] or [Array] of [String] of valid host names
  sig { override.returns(T::Array[String]) }
  def self.valid_host_name
    ["www.youtube.com", "youtube.com", "youtu.be", "m.youtube.com"]
  end

  # Validate that the url is a direct link to a Youtube video
  #
  # @note this assumes a valid url or else it'll always (usually, maybe, whatever) fail
  #
  # @!scope class
  # @!visibility private
  # @params url [String] a url to validate
  # @return [Boolean] if the string validates or not
  sig { params(url: String).returns(T::Boolean) }
  def self.validate_youtube_post_url(url)
    self.valid_host_name.each do |host_name|
      return true if /#{host_name}\//.match?(url)
    end
    raise InvalidYoutubePostUrlError, "Youtube url #{url} does not have the standard url format"
  end

  # Initialize the object and capture the screenshot automatically.
  #
  # @params url [String] the url of the page to be collected for archiving
  # @returns [Sting or nil] the path of the screenshot if the screenshot was saved
  sig { params(url: String).void }
  def initialize(url)
    # Verify that the url has the proper host for this source. (@valid_host is set at the top of
    # this class)
    begin
      YoutubeMediaSource.check_url(url)
      YoutubeMediaSource.validate_youtube_post_url(url)
    rescue MediaSource::HostError, InvalidYoutubePostUrlError
      @invalid_url = true
    end

    @url = url
  end
end

# A class to indicate that a post url passed in is invalid
class YoutubeMediaSource::InvalidYoutubePostUrlError < StandardError; end
