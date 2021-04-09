# typed: true
class WebsiteMediaSource < MediaSource
  attr_reader(:url)

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
end
