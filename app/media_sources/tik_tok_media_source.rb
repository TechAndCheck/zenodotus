# typed: true

class TikTokMediaSource < MediaSource
  attr_reader(:url, :invalid_url)

  # Limit all urls to the host below
  #
  # @return [String] or [Array] of [String] of valid host names
  sig { override.returns(T::Array[String]) }
  def self.valid_host_name
    ["www.tiktok.com", "tiktok.com"]
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
      TikTokMediaSource.check_url(url)
      TikTokMediaSource.validate_tiktok_post_url(url)
    rescue MediaSource::HostError, InvalidTikTokPostUrlError
      @invalid_url = true
    end

    @url = url
  end

private

  # Validate that the url is a direct link to a post, poorly
  #
  # @note this assumes a valid url or else it'll always (usually, maybe, whatever) fail
  #
  # @!scope class
  # @!visibility private
  # @params url [String] a url to check if it's a valid TikTok post url
  # @return [Boolean] if the string validates or not
  sig { params(url: String).returns(T::Boolean) }
  def self.validate_tiktok_post_url(url)
    self.valid_host_name.each do |host_name|
      return true if /https:\/\/#{host_name}\/@[\w.-]+\/video\/[0-9]+/.match?(url)
    end

    raise InvalidTikTokPostUrlError, "TikTok url #{url} does not have the standard url format"
  end

  # Grab the ID from the end of a TikTok URL
  #
  # @note this assumes a valid url or else it'll return weird stuff
  # @!scope class
  # @!visibility private
  # @params url [String] a url to extract an id from
  # @return [String] the id from the url or [Nil]
  sig { params(url: String).returns(T.nilable(String)) }
  def self.extract_tik_tok_id_from_url(url)
    uri = URI(url)
    splits = T.must(uri.path).split("/")
    raise TikTokMediaSource::InvalidTikTokPostUrlError if splits.empty?

    splits[2]
  end
end

# A class to indicate that a post url passed in is invalid
class TikTokMediaSource::InvalidTikTokPostUrlError < StandardError; end
