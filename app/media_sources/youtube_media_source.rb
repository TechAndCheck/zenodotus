# typed: true
class YoutubeMediaSource < MediaSource
  attr_reader(:url)

  # Returns a list of valid hosts.
  #
  # @return [Array] of [String] of valid host names
  sig { override.returns(T::Array[String]) }
  def self.valid_host_name
    ["www.youtube.com", "youtube.com"]
  end

  # Begins the scraping process by sending a scrape request to Hypatia
  #
  # @!scope class
  # @params url [String] the url of the page to be collected for post archiving
  # @params force [Boolean] When set to true, forces Hypatia to immediately process a scrape request
  #   Default: false
  # @returns [Boolean or Hash] if `force` is set to `true` returns the scraped hash. Otherwise returns the status of the Hypatia job.
  sig { override.params(url: String, force: T::Boolean).returns(T.any(T::Boolean, T::Hash[String, String])) }
  def self.extract(url, force = false)
    object = self.new(url)
    return object.retrieve_youtube_post! if force
    object.retrieve_youtube_post
  end

  # Initialize the YoutubeMediaSource object
  #
  # @params url [String] the url of the page to be collected for archiving
  # @returns [nil]
  sig { params(url: String).void }
  def initialize(url)
    # Verify that the url has the proper host for this source. (@valid_host is set at the top of
    # this class)
    YoutubeMediaSource.check_url(url)
    YoutubeMediaSource.validate_youtube_post_url(url)
    @url = url
  end

  # Sends a scrape request to Hypatia, which Hypatia responds to with a staus response.
  # Hpyatia will POST the scraped media content to Zenodotus in a later callback
  #
  # @!visibility private
  # @params url [String] a url to grab data for
  # @return [Boolean]
  sig { returns(T::Boolean) }
  def retrieve_youtube_post
    scrape = Scrape.create!({ url: @url, scrape_type: :youtube })

    params = { auth_key: Figaro.env.HYPATIA_AUTH_KEY, url: @url, callback_id: scrape.id }
    params[:callback_url] = Figaro.env.URL unless Figaro.env.URL.blank?

    response = Typhoeus.get(
      Figaro.env.HYPATIA_SERVER_URL,
      followlocation: true,
      params: params
    )

    raise ExternalServerError, "Error: #{response.code} returned from external Hypatia server" unless response.code == 200
    response_body = JSON.parse(response.body)
    raise YoutubeMediaSource::ExternalServerError if response_body["success"] == false

    true
  end

  # Sends a scrape request to Hypatia and forces the server to process it immediately
  # This should only be used for testing purposes.
  #
  # @return [Hash]
  sig { returns(Hash) }
  def retrieve_youtube_post!
    scrape = Scrape.create!({ url: @url, scrape_type: :youtube })

    params = { auth_key: Figaro.env.HYPATIA_AUTH_KEY, url: @url, callback_id: scrape.id, force: "true" }
    params[:callback_url] = Figaro.env.URL unless Figaro.env.URL.blank?

    response = Typhoeus.get(
      Figaro.env.HYPATIA_SERVER_URL,
      followlocation: true,
      params: params
    )

    raise ExternalServerError, "Error: #{response.code} returned from external Hypatia server" unless response.code == 200
    returned_data = JSON.parse(response.body)
    returned_data["scrape_result"] = JSON.parse(returned_data["scrape_result"])
    returned_data
  end

  private

    # Validate that a url links to a YouTube video
    #
    # @note this assumes a valid url or else it'll always (usually, maybe, whatever) fail
    #
    # @!scope class
    # @!visibility private
    # @params url [String] a url to validate
    # @return [Boolean] if the string validates or not
    sig { params(url: String).returns(T::Boolean) }
    def self.validate_youtube_post_url(url)
      return true if /youtube.com\//.match?(url)
      raise InvalidYoutubePostUrlError, "Youtube url #{url} does not have the standard url format"
    end
end

class YoutubeMediaSource::InvalidYoutubePostUrlError < StandardError; end
class YoutubeMediaSource::ExternalServerError < StandardError; end
