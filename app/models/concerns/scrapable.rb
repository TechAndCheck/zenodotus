module Scrapable
  extend ActiveSupport::Concern
  extend T::Sig

  module ClassMethods
    extend T::Sig

    # Spawns an ActiveJob tasked with creating an +ArchiveItem+ from a +url+ as a string
    #
    # @!scope class
    # @params url String a string of a url
    # @params user the user adding the ArchiveItem
    # returns ScrapeJob
    sig { params(url: String, user: T.nilable(User), media_review: T.nilable(MediaReview)).returns(ScrapeJob) }
    def create_from_url(url, user = nil, media_review: nil)
      # Check if `scrape_type` is defined
      raise "`scrape_type` must be defined on an object with the Scrapable concern" unless self.respond_to?(:scrape_type)

      scrape_type = self.scrape_type
      raise "`scrape_type` must return an instance of MediaSource::ScrapeType" unless scrape_type.is_a?(MediaSource::ScrapeType)

      scrape = Scrape.create!({ url: url, scrape_type: scrape_type.serialize, media_review: media_review })
      scrape.enqueue
    end
  end
end
