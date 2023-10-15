# typed: true

class FacebookMediaSource < MediaSource
  include Forki
  attr_reader(:url, :invalid_url)

  # Limit all urls to the host below
  #
  # @return [String] or [Array] of [String] of valid host names
  sig { override.returns(T::Array[String]) }
  def self.valid_host_name
    ["www.facebook.com", "m.facebook.com", "web.facebook.com"]
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
    self.valid_host_name.each do |host_name|
      return true if /#{host_name}\//.match?(url)
    end

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
    begin
      FacebookMediaSource.check_url(url)
      FacebookMediaSource.validate_facebook_post_url(url)
    rescue MediaSource::HostError, InvalidFacebookPostUrlError
      @invalid_url = true
    end

    @url = url
  end
end

# A class to indicate that a post url passed in is invalid
class FacebookMediaSource::InvalidFacebookPostUrlError < StandardError; end
