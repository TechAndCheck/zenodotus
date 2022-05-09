# typed: true
class FacebookMediaSource < MediaSource
  include Forki
  attr_reader(:url)

  # Returns a list of valid hosts
  #
  # @return [String] or [Array] of [String] of valid host names
  sig { override.returns(T::Array[String]) }
  def self.valid_host_name
    ["www.facebook.com"]
  end

  # Begins the scraping process by sending a scrape request to Hypatia
  #
  # @!scope class
  # @params url [String] the url of the page to be collected for post archiving
  # @params force [Boolean] When set to true, forces Hypatia to immediately process a scrape request
  #   Default: false
  # @returns [Boolean or Hash] if `force` is set to `true` returns the scraped hash. Otherwise returns the status of the Hypatia job.
  sig { override.params(url: String, force: T::Boolean).returns(T.any(T::Boolean,  T::Hash[String, String])) }
  def self.extract(url, force = false)
    object = self.new(url)
    return object.retrieve_facebook_post! if force

    object.retrieve_facebook_post
  end

  # Initializes the FacebookMediaSource object
  #
  # @params url [String] the url of the page to be scraped for archiving
  # @returns [nil]
  sig { params(url: String).void }
  def initialize(url)
    # Verify that the url has the proper host for this source. (valid hosts are set at the top of
    # this class)
    FacebookMediaSource.check_url(url)
    FacebookMediaSource.validate_facebook_post_url(url)
    @url = url
  end

  # Sends a scrape request to Hypatia, which Hypatia responds to with a staus response.
  # Hpyatia will POST the scraped media content to Zenodotus in a later callback
  #
  # @!visibility private
  # @params url [String] a url to grab data for
  # @return [Boolean]
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

    raise ExternalServerError, "Error: #{response.code} returned from Hypatia server" unless response.code == 200
    response_body = JSON.parse(response.body)
    raise FacebookMediaSource::ExternalServerError if response_body["success"] == false

    true
  end

  # Sends a scrape request to Hypatia and forces the server to process it immediately
  # This should only be used for testing purposes.
  #
  # @return [Hash]
  sig { returns(Hash) }
  def retrieve_facebook_post!
    scrape = Scrape.create!({ url: @url, scrape_type: :facebook })

    params = { auth_key: Figaro.env.HYPATIA_AUTH_KEY, url: @url, callback_id: scrape.id, force: true }
    params[:callback_url] = Figaro.env.URL unless Figaro.env.URL.blank?

    response = Typhoeus.get(
      Figaro.env.HYPATIA_SERVER_URL,
      followlocation: true,
      params: params
    )

    raise ExternalServerError, "Error: #{response.code} returned from Hypatia server" unless response.code == 200

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
    # @params url [String] a url to check if it's a valid Facebook post url
    # @return [Boolean] if the string validates or not
    sig { params(url: String).returns(T::Boolean) }
    def self.validate_facebook_post_url(url)
      return true if /facebook.com\//.match?(url)
      raise InvalidFacebookPostUrlError, "Facebook url #{url} does not have the standard url format"
    end
end

# A class to indicate that a post url passed in is invalid
class FacebookMediaSource::InvalidFacebookPostUrlError < StandardError; end
class FacebookMediaSource::ExternalServerError < StandardError; end
