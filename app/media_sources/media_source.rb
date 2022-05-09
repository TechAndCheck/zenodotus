# typed: true

class MediaSource
  extend T::Sig
  extend T::Helpers
  abstract!

  # Limit all urls to the host(s) below, use the private method {#self.check_host} in your initializer
  # to check for a valid host or not.
  #
  # @note If your scraper doesn't enforce a host name (for a basic web scraper for instance),
  #   just have this return an empty array.
  # @return [Array] of [String] of valid host names
  sig { abstract.returns(T::Array[String]) }
  def self.valid_host_name; end

  # An abstract method that facilitates the scraping/retrieval of content
  #
  # @note This should be overwritten by any implementing class.
  #
  # @!scope class
  # @param url [String] the url of the page/object to be collected for archiving
  # @params force [Boolean] When set to true, forces Hypatia to immediately process a scrape request.
  #    The `force` parameter is only implemented for MediaSources that interact with Hypatia
  # @return
  sig { abstract.params(url: String).returns(T.untyped) }
  def self.extract(url); end

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

  # This is a flag if the scraper is run by Hypatia or locally, mostly so the ScraperJob can know
  # Default is false if not implemented
  #
  # @!scope class
  # @return [Boolean] true if the scraper is run locally.
  #   Raises an error if it's invalid.
  sig { returns(T::Boolean) }
  def self.runs_scraper_locally?
    false
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
