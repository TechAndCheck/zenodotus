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

  # Capture a screenshot of the given url
  #
  # @!scope class
  # @params url [String] the url of the page to be collected for archiving
  # @params force [Boolean] force Hypatia to not queue a request but to scrape immediately.
  #   Default: false
  # @returns [String or nil] the path of the screenshot if the screenshot was saved
  sig { override.params(url: String, force: T::Boolean).returns(T.any(T::Boolean, T::Hash[String, String])) }
  def self.extract(url, force = false)
    url = MediaSource.extract_post_url_if_needed(url)
    object = self.new(url)

    return object.retrieve_tweet! if force

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
  sig { returns(T::Boolean) }
  def retrieve_tweet
    scrape = Scrape.create!({ url: @url, scrape_type: :twitter })

    params = { auth_key: Figaro.env.HYPATIA_AUTH_KEY, url: @url, callback_id: scrape.id }
    params[:callback_url] = Figaro.env.MEDIA_VAULT_URL unless Figaro.env.MEDIA_VAULT_URL.blank?

    response = Typhoeus.get(
      Figaro.env.HYPATIA_SERVER_URL,
      followlocation: true,
      params: params
    )

    unless response.code == 200
      scrape.error
      raise TwitterMediaSource::ExternalServerError, "Error: #{response.code} returned from Hypatia server"
    end

    response_body = JSON.parse(response.body)
    raise TwitterMediaSource::ExternalServerError if response_body["success"] == false

    true
  end

  # Scrape the page by sending it to Hypatia and forcing the server to process the job immediately. Should only be used for tests
  #
  # @return [Hash]
  sig { returns(Hash) }
  def retrieve_tweet!
    scrape = Scrape.create!({ url: @url, scrape_type: :twitter })

    params = { auth_key: Figaro.env.HYPATIA_AUTH_KEY, url: @url, callback_id: scrape.id, force: true }
    params[:callback_url] = Figaro.env.MEDIA_VAULT_URL unless Figaro.env.MEDIA_VAULT_URL.blank?

    response = Typhoeus.get(
      Figaro.env.HYPATIA_SERVER_URL,
      followlocation: true,
      params: params
    )

    unless response.code == 200
      scrape.error
      raise TwitterMediaSource::ExternalServerError, "Error: #{response.code} returned from Hypatia server"
    end

    returned_data = JSON.parse(response.body)
    returned_data["scrape_result"] = JSON.parse(returned_data["scrape_result"])
    returned_data
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
class TwitterMediaSource::ExternalServerError < StandardError; end
