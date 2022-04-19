# typed: true
class FacebookMediaSource < MediaSource
  include Forki
  attr_reader(:url)

  # Limit all urls to the host below
  #
  # @return [String] or [Array] of [String] of valid host names
  sig { override.returns(T::Array[String]) }
  def self.valid_host_name
    ["www.facebook.com"]
  end

  # Extracts the post at the input URL by forwarding a scraping request to Hypatia
  #
  # @!scope class
  # @params url [String] the url of the page to be collected for archiving
  # @params force [Boolean] force Hypatia to not queue a request but to scrape immediately.
  #   Default: false
  # @returns [String or nil] the path of the screenshot if the screenshot was saved
  sig { override.params(url: String, force: T::Boolean).returns(T.any(T::Boolean,  T::Hash[String, String])) }
  def self.extract(url, force = false)
    object = self.new(url)
    return object.retrieve_facebook_post! if force

    object.retrieve_facebook_post
  end

  # Validate that the url is a direct link to a post, poorly
  #
  # @note this assumes a valid url or else it'll always (usually, maybe, whatever) fail
  #
  # @!scope class
  # @!visibility private
  # @params url [String] a url to check if it's a valid Facebook post url
  # @return [Boolean] if the string validates or not
  sig { params(url: String).returns(T::Boolean) }
  def self.validate_facebook_post_url(url)
    return true if /facebook.com\//.match?(url)
    raise InvalidFacebookPostUrlError, "Facebook url #{url} does not have the standard url format"
  end

  # Initialize the object and capture the screenshot automatically.
  #
  # @params url [String] the url of the page to be collected for archiving
  # @returns [Sting or nil] the path of the screenshot if the screenshot was saved
  sig { params(url: String).void }
  def initialize(url)
    # Verify that the url has the proper host for this source. (@valid_host is set at the top of
    # this class)
    FacebookMediaSource.check_url(url)
    @url = url
  end

  # Scrape the page by sending it to Hypatia
  #
  # @!visibility private
  # @params url [String] a url to grab data for
  # @return [Forki::Post]
  sig { returns(T::Boolean) }
  def retrieve_facebook_post
    scrape = Scrape.create!({ url: @url, scrape_type: :facebook })

    params = { auth_key: Figaro.env.HYPATIA_AUTH_KEY, url: @url, callback_id: scrape.id }
    params[:callback_url] = Figaro.env.URL unless Figaro.env.URL.blank?

    response = Typhoeus.get(
      Figaro.env.HYPATIA_SERVER_URL,
      followlocation: true,
      params: params
    )

    raise ExternalServerError, "Error: #{response.code} returned from external Hypatia server" unless response.code == 200
    response_body = JSON.parse(response.body)
    # _ = JSON.parse(response.body)
    # TODO:  Parse response body properly and check for errors
    raise InstagramMediaSource::ExternalServerError if response_body["success"] == false

    true
  end

  # Scrape the page by sending it to Hypatia and forcing the server to process the job immediately. Should only be used for tests
  #
  # @return [Hash]
  sig { returns(Hash) }
  def retrieve_facebook_post!
    scrape = Scrape.create!({ url: @url, scrape_type: :instagram })

    params = { auth_key: Figaro.env.ZORKI_AUTH_KEY, url: @url, callback_id: scrape.id, force: true }
    params[:callback_url] = Figaro.env.URL unless Figaro.env.URL.blank?

    response = Typhoeus.get(
      Figaro.env.HYPATIA_SERVER_URL,
      followlocation: true,
      params: params
    )

    raise ExternalServerError, "Error: #{response.code} returned from external Forki server" unless response.code == 200
    returned_data = JSON.parse(response.body)
    returned_data["scrape_result"] = JSON.parse(returned_data["scrape_result"])
    returned_data
  end
end

# A class to indicate that a post url passed in is invalid
class FacebookMediaSource::InvalidFacebookPostUrlError < StandardError; end
class FacebookMediaSource::ExternalServerError < StandardError; end
