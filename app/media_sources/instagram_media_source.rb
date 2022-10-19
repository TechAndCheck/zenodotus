# typed: true

class InstagramMediaSource < MediaSource
  attr_reader(:url)

  # Limit all urls to the host below
  #
  # @return [String] or [Array] of [String] of valid host names
  sig { override.returns(T::Array[String]) }
  def self.valid_host_name
    ["www.instagram.com", "instagram.com"]
  end

  # Set off a scrape on Instagram using a Hypatia instance. This will then be finished up when the
  # callback is instantiated.
  #
  # @!scope class
  # @params url [String] the url of the page to be collected for archiving
  # @params force [Boolean] whether to force Hypatia to not queue a request but to scrape immediately.
  #   Default: false
  # @returns [Boolean or Hash] if `force` is set to `true` returns the scraped hash, otherwise the status of the Hypatia job.
  sig { override.params(url: String, force: T::Boolean).returns(T.any(T::Boolean, T::Hash[String, String])) }
  def self.extract(url, force = false)
    url = MediaSource.extract_post_url_if_needed(url)
    object = self.new(url)

    return object.retrieve_instagram_post! if force

    object.retrieve_instagram_post
  end

  # Initialize the object and capture the screenshot automatically.
  #
  # @params url [String] the url of the page to be collected for archiving
  # @returns [Sting or nil] the path of the screenshot if the screenshot was saved
  sig { params(url: String).void }
  def initialize(url)
    # Verify that the url has the proper host for this source. (@valid_host is set at the top of
    # this class)
    InstagramMediaSource.check_url(url)
    InstagramMediaSource.validate_instagram_post_url(url)

    @url = url
  end

  # Set off a scrape on Instagram using a Hypatia instance. This will then be finished up when the
  # callback is instantiated.
  #
  # @return [Boolean]
  sig { returns(T::Boolean) }
  def retrieve_instagram_post
    scrape = Scrape.create!({ url: @url, scrape_type: :instagram })

    params = { auth_key: Figaro.env.HYPATIA_AUTH_KEY, url: @url, callback_id: scrape.id }

    response = Typhoeus.get(
      Figaro.env.HYPATIA_SERVER_URL,
      followlocation: true,
      params: params
    )

    unless response.code == 200
      scrape.error
      raise ExternalServerError, "Error: #{response.code} returned from Hypatia server"
    end

    response_body = JSON.parse(response.body)
    # _ = JSON.parse(response.body)
    # TODO:  Parse response body properly and check for errors
    raise InstagramMediaSource::ExternalServerError if response_body["success"] == false
    true
  end

  # Forces a Hypatia instance to run immediately. This should only be used for testing purposes.
  #
  # @return [Hash]
  sig { returns(Hash) }
  def retrieve_instagram_post!
    scrape = Scrape.create!({ url: @url, scrape_type: :instagram })

    params = { auth_key: Figaro.env.HYPATIA_AUTH_KEY, url: @url, callback_id: scrape.id, force: true }

    response = Typhoeus.get(
      Figaro.env.HYPATIA_SERVER_URL,
      followlocation: true,
      params: params
    )

    unless response.code == 200
      scrape.error
      raise ExternalServerError, "Error: #{response.code} returned from Hypatia server"
    end

    # Hypatia returns arrays always so we grab the first
    returned_data = JSON.parse(response.body)
    returned_data["scrape_result"] = JSON.parse(returned_data["scrape_result"])
    returned_data
  end

private

  # Validate that the url is a direct link to a post, poorly
  #
  # @note this assumes a valid url or else it'll always (usually, maybe, whatever) fail
  #
  # @!scope class
  # @!visibility private
  # @params url [String] a url to check if it's a valid Instagram post url
  # @return [Boolean] if the string validates or not
  sig { params(url: String).returns(T::Boolean) }
  def self.validate_instagram_post_url(url)
    return true if /instagram.com\/((p)|(reel)|(tv))\/[\w]+/.match?(url)
    raise InvalidInstagramPostUrlError, "Instagram url #{url} does not have the standard url format"
  end

  # Grab the ID from the end of an Instagram URL
  #
  # @note this assumes a valid url or else it'll return weird stuff
  # @!scope class
  # @!visibility private
  # @params url [String] a url to extract an id from
  # @return [String] the id from the url or [Nil]
  sig { params(url: String).returns(T.nilable(String)) }
  def self.extract_instagram_id_from_url(url)
    uri = URI(url)
    splits = T.must(uri.path).split("/")
    raise InstagramMediaSource::InvalidInstagramPostUrlError if splits.empty?

    splits[2]
  end
end

# A class to indicate that a post url passed in is invalid
class InstagramMediaSource::InvalidInstagramPostUrlError < StandardError; end
class InstagramMediaSource::ExternalServerError < StandardError; end
