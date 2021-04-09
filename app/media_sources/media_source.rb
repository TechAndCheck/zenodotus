# typed: true
class MediaSource
  extend T::Sig
  extend T::Helpers
  abstract!

  # An abstract method that acts as the entry point to a MediaSource subclass.
  #
  # @note This should be overwritten by any implementing class.
  #
  # @!scope class
  # @param url [String] the url of the page/object to be collected for archiving
  # @return [nil]
  sig { abstract.params(url: String).returns(T.nilable(String)) }
  def self.extract(url); end
end
