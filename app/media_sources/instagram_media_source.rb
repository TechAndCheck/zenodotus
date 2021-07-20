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

  # Capture a screenshot of the given url
  #
  # @!scope class
  # @params url [String] the url of the page to be collected for archiving
  # @params save_screenshot [Boolean] whether to save the screenshot image (mostly for testing).
  #   Default: false
  # @returns [String or nil] the path of the screenshot if the screenshot was saved
  sig { override.params(url: String, save_screenshot: T::Boolean).returns(T::Array[Zorki::Post]) }
  def self.extract(url, save_screenshot = false)
    object = self.new(url)
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

  # Scrape the page using the Zorki gem and get an object
  #
  # @!visibility private
  # @params url [String] a url to grab data for
  # @return [Zorki::Post]
  sig { returns(T::Array[Zorki::Post]) }
  def retrieve_instagram_post
    id = InstagramMediaSource.extract_instagram_id_from_url(@url)
    Zorki::Post.lookup(id)
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
    return true if /instagram.com\/((p)|(reel))\/[\w]+/.match?(url)
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
