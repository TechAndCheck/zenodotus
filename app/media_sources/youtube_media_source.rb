# typed: true

class YoutubeMediaSource < MediaSource
  attr_reader(:url)

  # Limit all urls to the host below
  #
  # @return [String] or [Array] of [String] of valid host names
  sig { override.returns(T::Array[String]) }
  def self.valid_host_name
    ["www.youtube.com", "youtube.com"]
  end

  # Extracts the video at the input URL by forwarding a scraping request to Hypatia
  #
  # @!scope class
  # @params url [String] the url of the page to be collected for archiving
  # @params force [Boolean] force Hypatia to not queue a request but to scrape immediately.
  #   Default: false
  # @returns Boolean
  sig { override.params(url: String, force: T::Boolean).returns(T.any(T::Boolean, T::Hash[String, String])) }
  def self.extract(url, force = false)
    object = self.new(url)
    return object.retrieve_youtube_post! if force
    object.retrieve_youtube_post
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
    return true if /youtube.com\//.match?(url)
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
    YoutubeMediaSource.check_url(url)
    @url = url
  end

  # Scrape the page by sending it to Hypatia
  #
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

    unless response.code == 200
      scrape.error
      raise ExternalServerError, "Error: #{response.code} returned from Hypatia server"
    end

    response_body = JSON.parse(response.body)
    raise YoutubeMediaSource::ExternalServerError if response_body["success"] == false

    true
  end

  # Scrape the page by sending it to Hypatia and forcing the server to process the job immediately. Should only be used for tests
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

    unless response.code == 200
      scrape.error
      raise ExternalServerError, "Error: #{response.code} returned from Hypatia server"
    end

    returned_data = JSON.parse(response.body)
    returned_data["scrape_result"] = JSON.parse(returned_data["scrape_result"])
    returned_data
  end
end

# A class to indicate that a post url passed in is invalid
class YoutubeMediaSource::InvalidYoutubePostUrlError < StandardError; end
class YoutubeMediaSource::ExternalServerError < StandardError; end
