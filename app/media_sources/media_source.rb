# typed: true

class MediaSource
  extend T::Sig
  extend T::Helpers
  abstract!

  # Limit all urls to the host(s) below, use the private method {#self.check_host} in your initializer
  # to check for a valid host or not.
  #
  # @note If your scraper doesn't enforce a host name (for a basic web scraper for instance),
  #   just have this return `nil` or any empty array . We can discuss if this should be an
  #   enforced abstract method if this becomes an issue.
  # @return [Array] of [String] of valid host names or [nil]
  sig { abstract.returns(T.nilable(T::Array[String])) }
  def self.valid_host_name; end

  # An abstract method that acts as the entry point to a MediaSource subclass.
  #
  # @note This should be overwritten by any implementing class.
  #
  # @!scope class
  # @param url [String] the url of the page/object to be collected for archiving
  # @return [nil]
  sig { abstract.params(url: String).returns(T.untyped) }
  def self.extract(url); end

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
    fix_post_url_in_archive_org_url!(url)
    split_url = url.rpartition(/https?:\/\//) # partition string based on last occurence of "http(s)://" to get original url
    split_url[1] + split_url[2] # return original URL scheme + rest of original URL
  end

  sig { params(url: String).void }
  def self.fix_post_url_in_archive_org_url!(url)
    url.gsub!(/:(\/)[^\/]/) { |s|s.gsub("/", "//") }
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
end
