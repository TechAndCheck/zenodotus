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
