# typed: true

class TwitterMediaSource < MediaSource
  attr_reader(:url)

  # Limit all urls to the host below
  # @return [String] or [Array] of [String] of valid host names
  sig { override.returns(T::Array[String]) }
  def self.valid_host_name
    ["www.twitter.com", "twitter.com"]
  end

  # Capture a screenshot of the given url
  #
  # @!scope class
  # @params url [String] the url of the page to be collected for archiving
  # @params save_screenshot [Boolean] whether to save the screenshot image (mostly for testing).
  #   Default: false
  # @returns Sting or nil] the path of the screenshot if the screenshot was saved
  sig { override.params(url: String, save_screenshot: T::Boolean).returns(T.nilable(String)) }
  def self.extract(url, save_screenshot = false)
    object = self.new(url)
    object.capture_screenshot(save_screenshot)
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

  # Perform the proper capture of the url passed in
  #
  # @params save_screenshot [Boolean] whether to save the screenshot image (mostly for testing).
  #   Returns the path of the screenshot if true. Default: false
  # @return [File] file object of the image
  sig { params(save_screenshot: T::Boolean).returns(T.nilable(String)) }
  def capture_screenshot(save_screenshot = false)
    filename = "#{SecureRandom.uuid()}.png"
    path = Rails.root.join("tmp", filename)

    browser = Ferrum::Browser.new
    browser.go_to(@url)
    browser.screenshot(path: path)
    browser.quit

    return path.to_s if save_screenshot

    File.delete(path)
    nil
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
    return true if /twitter.com\/[\w]+\/[\w]+\/[0-9]+\z/.match?(url)
    raise InvalidTweetUrlError, "Tweet url #{url} does not have standard the standard url format"
  end
end

# A class to indicate that a tweet url passed in is invalid
class TwitterMediaSource::InvalidTweetUrlError < StandardError; end
