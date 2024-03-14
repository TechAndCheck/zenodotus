# typed: true

class MediaSource
  extend T::Sig
  extend T::Helpers
  abstract!

  class ScrapeType < T::Enum
    # (2) Enum values are declared within an `enums do` block
    enums do
      Facebook = new
      Instagram = new
      Youtube = new
      Twitter = new
      TikTok = new
    end
  end

  # Limit all urls to the host(s) below, use the private method {#self.check_host} in your initializer
  # to check for a valid host or not.
  #
  # @note If your scraper doesn't enforce a host name (for a basic web scraper for instance),
  #   just have this return `nil` or any empty array . We can discuss if this should be an
  #   enforced abstract method if this becomes an issue.
  # @return [Array] of [String] of valid host names or [nil]
  sig { abstract.returns(T.nilable(T::Array[String])) }
  def self.valid_host_name; end

  # Given a possibly ofuscated media post URL, return a URL pointing to the source of the post
  # If the input URL already points to the source of the post, return the input URL
  # Right now, this method just extracts post URLs from archive.org URLs, but we might add further layers of extraction in the future
  #
  # @!scope class
  # @param url [String] the URL of a media post to be archived. May be obfuscated
  # @return [String] A direct URL to the page/object to be archived
  sig { params(url: String).returns(String) }
  def self.extract_post_url_if_needed(url)
    url = self.extract_post_url_from_archive_org_url(url)
    url
  end

  # Extracts a MediaSource post URL from a potential archive.org URL
  # If the input url turns out not to be an archive.org URL, returns the input URL untouched
  #
  # E.g. Given an input of https://web.archive.org/web/20190615000000*/https://www.foobar.com/post1
  # This function will return https://www.foobar.com/post1
  # Given an input of https://www.foobar.com/post1, it will return the input
  #
  # @!scope class
  # @param url [String] the URL of a media post to be archived. May be an archive.org URL instead of a direct URL
  # @return [String] A direct URL to the page/object to be archived
  sig { params(url: String).returns(String) }
  def self.extract_post_url_from_archive_org_url(url)
    url = fix_post_url_in_archive_org_url(url)
    split_url = url.rpartition(/https?:\/\//) # partition string based on last occurence of "http(s)://" to get original url
    split_url[1] + split_url[2] # return original URL scheme + rest of original URL
  end

  sig { params(url: String).returns(String) }
  def self.fix_post_url_in_archive_org_url(url)
    url.gsub(/:(\/)[^\/]/) { |s|s.gsub("/", "//") }
  end

  # Check if +url+ has a host name the same as indicated by the +@@valid_host+ variable in a
  #   subclass.
  #
  # @!scope class
  # @param url [String] the url to be checked for validity
  # @return [Boolean] if the url is valid given the set @@valid_host.
  #   Raises an error if it's invalid.
  sig { params(url: String).returns(T::Boolean) }
  def self.check_url(url)
    return true if T.must(self.valid_host_name).include?(URI(url).host)

    raise MediaSource::HostError.new(url, self)
  end

  # Retrieve the post of the given url
  #
  # @!scope class
  # @params url [String] the url of the page to be collected for archiving
  # @params force [Boolean] force Hypatia to not queue a request but to scrape immediately.
  #   Default: false
  # @returns [String or nil] the path of the screenshot if the screenshot was saved
  sig { params(url: String, scrape_type: ScrapeType, force: T::Boolean, media_review: T.nilable(MediaReview)).returns(T.any(T.nilable(T::Boolean),  T::Hash[String, String])) }
  def self.extract(url, scrape_type, force = false, media_review: nil)
    url = MediaSource.extract_post_url_if_needed(url)
    object = self.new(url)

    return nil if object.invalid_url
    return object.retrieve_post!(scrape_type, media_review: media_review) if force

    object.retrieve_post(scrape_type, media_review: media_review)
  end

  # Scrape the page by sending it to Hypatia
  #
  # @!visibility private
  # @params url [String] a url to grab data for
  # @return [Forki::Post]
  sig { params(scrape_type: ScrapeType, media_review: T.nilable(MediaReview)).returns(T::Boolean) }
  def retrieve_post(scrape_type, media_review: nil)
    scrape = Scrape.create!({ url: @url, scrape_type: scrape_type.serialize, media_review: media_review })
    !scrape.nil?
  end

  # Scrape the page by sending it to Hypatia and forcing the server to process the job immediately. Should only be used for tests
  #
  # @return [Hash]
  sig { params(scrape_type: ScrapeType, media_review: T.nilable(MediaReview)).returns(Hash) }
  def retrieve_post!(scrape_type, media_review: nil)
    scrape = Scrape.create!({ url: @url, scrape_type: scrape_type.serialize, media_review: media_review })

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

    returned_data = JSON.parse(response.body)
    returned_data["scrape_result"] = JSON.parse(returned_data["scrape_result"])
    returned_data
  end

  # A error to indicate the host of a given url does not pass validation
  class HostError < StandardError
    extend T::Sig
    extend T::Helpers

    attr_reader :url
    attr_reader :class

    sig { params(url: String, clazz: Class).returns(MediaSource::HostError) }
    def initialize(url, clazz)
      @url = url
      @class = T.let(clazz, T.untyped) # This is specified to remove some checking errors on the next line

      super("Invalid URL passed to #{@class.name}, must have host #{@class.valid_host_name}, given #{URI(url).host}")
    end
  end

  class ExternalServerError < StandardError; end
end
