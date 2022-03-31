# typed: ignore

class TwitterMediaSource < MediaSource
  attr_reader(:url)

  # Limit all urls to the host below
  #
  # @return [String] or [Array] of [String] of valid host names
  sig { override.returns(T::Array[String]) }
  def self.valid_host_name
    ["www.twitter.com", "twitter.com"]
  end

  # This is a flag if the scraper is run by Hypatia or locally, mostly so the ScraperJob can know
  # Default is false if not implemented
  #
  # @!scope class
  # @return [Boolean] true if the scraper is run locally.
  #   Raises an error if it's invalid.
  sig { returns(T::Boolean) }
  def self.runs_scraper_locally?
    true
  end

  # Capture a screenshot of the given url
  #
  # @!scope class
  # @params url [String] the url of the page to be collected for archiving
  # @params save_screenshot [Boolean] whether to save the screenshot image (mostly for testing).
  #   Default: false
  # @returns [String or nil] the path of the screenshot if the screenshot was saved
  sig { override.params(url: String, save_screenshot: T::Boolean).returns(T::Array[Birdsong::Tweet]) }
  def self.extract(url, save_screenshot = false)
    object = self.new(url)
    object.retrieve_tweet
  end

  # Initialize the object and capture the screenshot automatically.
  #
  # @params url [String] the url of the page to be collected for archiving
  # @returns [Sting or nil] the path of the screenshot if the screenshot was saved
  sig { params(url: String).void }
  def initialize(url)
    # Verify that the url has the proper host for this source. (@valid_host is set at the top of
    # this class)
    TwitterMediaSource.check_url(url)
    TwitterMediaSource.validate_tweet_url(url)

    @url = url
  end

  # Call the Twitter API using the Birdsong gem and get an object
  #
  # @!visibility private
  # @params url [String] a url to grab data for
  # @return [Birdsong::Tweet]
  sig { returns(T::Array[Birdsong::Tweet]) }
  def retrieve_tweet
    id = TwitterMediaSource.extract_tweet_id_from_url(@url)
    Birdsong::Tweet.lookup(id)
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
    return true if /twitter.com\/[\w]+\/[\w]+\/[0-9]+/.match?(url)
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
