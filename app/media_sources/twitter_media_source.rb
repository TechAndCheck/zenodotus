# typed: ignore

class TwitterMediaSource < MediaSource
  attr_reader(:url, :invalid_url)

  # Limit all urls to the host below
  #
  # @return [String] or [Array] of [String] of valid host names
  sig { override.returns(T::Array[String]) }
  def self.valid_host_name
    ["www.twitter.com", "twitter.com", "mobile.twitter.com", "x.com", "www.x.com", "mobile.x.com"]
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
      TwitterMediaSource.check_url(url)
      TwitterMediaSource.validate_tweet_url(url)
    rescue MediaSource::HostError, InvalidTweetUrlError
      @invalid_url = true
    end

    @url = url
  end

private

  # Validate that the url is a direct link to a tweet, poorly
  #
  # @note this assumes a valid url or else it'll always (usually, maybe, whatever) fail
  #
  # @!scope class
  # @!visibility private
  # @params url [String] a url to check if it's a valid Twitter tweet url
  # @return [Boolean] if the string validates or not
  sig { params(url: String).returns(T::Boolean) }
  def self.validate_tweet_url(url)
    self.valid_host_name.each do |host_name|
      return true if /#{host_name}\/[\w]+\/[\w]+\/[0-9]+/.match?(url)
    end
    raise InvalidTweetUrlError, "Tweet url #{url} does not have the standard url format"
  end

  # Grab the ID from the end of a twitter URL
  #
  # @note this assumes a valid url or else it'll return weird stuff
  # @!scope class
  # @!visibility private
  # @params url [String] a url to extract an id from
  # @return [String] the id from the url or [Nil]
  sig { params(url: String).returns(T.nilable(String)) }
  def self.extract_tweet_id_from_url(url)
    uri = URI(url)
    splits = T.must(uri.path).split("/")
    raise TwitterMediaSource::InvalidTweetUrlError if splits.empty?

    splits.last
  end
end

# A class to indicate that a tweet url passed in is invalid
class TwitterMediaSource::InvalidTweetUrlError < StandardError; end
