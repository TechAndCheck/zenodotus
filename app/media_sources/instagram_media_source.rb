# typed: true

class InstagramMediaSource < MediaSource
  attr_reader(:url, :invalid_url)

  # Limit all urls to the host below
  #
  # @return [String] or [Array] of [String] of valid host names
  sig { override.returns(T::Array[String]) }
  def self.valid_host_name
    ["www.instagram.com", "instagram.com"]
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
      InstagramMediaSource.check_url(url)
      InstagramMediaSource.validate_instagram_post_url(url)
    rescue MediaSource::HostError, InvalidInstagramPostUrlError
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
  # @params url [String] a url to check if it's a valid Instagram post url
  # @return [Boolean] if the string validates or not
  sig { params(url: String).returns(T::Boolean) }
  def self.validate_instagram_post_url(url)
    self.valid_host_name.each do |host_name|
      return true if /#{host_name}\/(?:p|reel|tv)\/([\w-]+)/.match?(url)
      return true if /#{host_name}\/[\w]+\/(?:p|reel|tv)\/([\w-]+)/.match?(url)
    end

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
    found_matches = /https:\/\/[www.]*instagram.com\/(?:p|reel|tv)\/([\w-]+)/.match(url)
    return found_matches[1] unless found_matches.nil?

    found_matches = /https:\/\/[www.]*instagram.com\/[\w]+\/(?:p|reel|tv)\/([\w-]+)/.match(url)
    return found_matches[1] unless found_matches.nil?

    raise InvalidInstagramPostUrlError, "Instagram url #{url} does not have the standard url format"
  end
end

# A class to indicate that a post url passed in is invalid
class InstagramMediaSource::InvalidInstagramPostUrlError < StandardError; end
