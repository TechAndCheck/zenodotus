# typed: strict

class MediaReview < ApplicationRecord
  include PgSearch::Model
  multisearchable against: :original_media_context_description

  belongs_to :archive_item, optional: true, class_name: "ArchiveItem"
  belongs_to :media_review_author, optional: true, class_name: "FactCheckOrganization"
  has_many :claim_reviews, foreign_key: :media_review_id, class_name: "ClaimReview", dependent: :destroy

  validates :author, presence: true
  validates :date_published, presence: true
  validates :item_reviewed, presence: true
  validates :media_authenticity_category, presence: true
  validates :url, presence: true
  validate  :media_review_author_must_be_recognized

  before_validation do |media_review|
    # See if there's a ClaimReviewAuthor already
    host = URI.parse(media_review.author["url"]).host
    matching_hosts = FactCheckOrganization.where(host_name: host).order(:name)
    self.media_review_author = matching_hosts.first unless matching_hosts.empty?
  end

  def media_review_author_must_be_recognized
    # Make sure that the author is included in our list of FactCheckOrganizations
    if self.media_review_author.nil?
      errors.add(:media_review_author, "must be created by a recognized Fact Check Organization")
    end
  end

  before_create do |media_review|
    duplicates = MediaReview.find_duplicates(media_review.url, media_review.author["name"])
    if duplicates.any?
      raise "Duplicate MediaReview found: #{duplicates.map(&:id)}"
    end
  end

  # All media review without an attached piece of archive
  scope :orphaned, -> { where("archive_item_id = ?", nil) }

  # Create or update a MediaReview Record using the input hash
  sig { params(media_review_hash: Hash,
               external_unique_id: T.nilable(String), # We won't have a uuid when we scrape mediareview from pages
               should_update: T::Boolean
              ).returns(MediaReview) }
  def self.create_or_update_from_media_review_hash(media_review_hash, external_unique_id, should_update)
    original_media_link = media_review_hash.has_key?("originalMediaLink") ? media_review_hash["originalMediaLink"] : nil

    if should_update
      mr = MediaReview.where(external_unique_id: external_unique_id).first
      mr.update!(
        media_url: media_review_hash["itemReviewed"]["contentUrl"],
        original_media_link: original_media_link,
        media_authenticity_category: media_review_hash["mediaAuthenticityCategory"],
        original_media_context_description: media_review_hash["originalMediaContextDescription"],
        date_published: media_review_hash["datePublished"],
        url: media_review_hash["url"],
        author: media_review_hash["author"],
        item_reviewed: media_review_hash["itemReviewed"]
      )
      mr.reload

      # Now, if there's no ArchiveItem, try to find one and put it in
      if mr.archive_item.nil?
        archive_item = ArchiveItem.find_by(url: mr.media_url)
        mr.archive_item = archive_item unless archive_item.nil?
        mr.save!

      end
    else
      mr = MediaReview.create!(
        media_url: media_review_hash["itemReviewed"]["contentUrl"],
        external_unique_id: external_unique_id,
        original_media_link: original_media_link,
        media_authenticity_category: media_review_hash["mediaAuthenticityCategory"],
        original_media_context_description: media_review_hash["originalMediaContextDescription"],
        date_published: media_review_hash["datePublished"],
        url: media_review_hash["url"],
        author: media_review_hash["author"],
        item_reviewed: media_review_hash["itemReviewed"]
      )
    end

    logger.debug "Checking if we can create claim review"
    if media_review_hash.include?("associatedClaimReview")
      logger.info "Sure enough, we're going to try!"
      # Try to find the claimReview already, so we don't duplicate

      cr = ClaimReview.where(url: media_review_hash["associatedClaimReview"]["url"], claim_reviewed: media_review_hash["associatedClaimReview"]["claimReviewed"])

      unless cr.empty?
        cr = cr.first

        logger.info "Found existing claim review with id #{cr.id}"
        unless cr.media_review == mr
          cr.media_review = mr
          cr.save!
        end

        logger.info "Found ClaimeReview with id #{cr.id} for media review with id #{mr.id}"
      else
        cr = ClaimReview.create!(
          date_published: media_review_hash["associatedClaimReview"]["datePublished"],
          url: media_review_hash["associatedClaimReview"]["url"],
          author: media_review_hash["associatedClaimReview"]["author"],
          claim_reviewed: media_review_hash["associatedClaimReview"]["claimReviewed"],
          review_rating: media_review_hash["associatedClaimReview"]["reviewRating"],
          item_reviewed: media_review_hash["associatedClaimReview"]["itemReviewed"],
          media_review: mr
        )

        logger.info "Created ClaimeReview with id #{cr.id} for media review with id #{mr.id}"
      end

    else
      logger.info "Hrm, we can't, let's check the json shall we?"
      logger.info media_review_hash.inspect
    end

    mr
  end

  sig { params(url: String, author_name: T.nilable(String)).returns(T::Array[MediaReview]) }
  def self.find_duplicates(url, author_name)
    # We'll compare based on url, and author
    possible_duplicates = MediaReview.where(url: url).order(:created_at)
    possible_duplicates.select do |possible_duplicate|
      possible_duplicate.author["name"] == author_name
    end
  end

  sig { returns(T::Array[MediaReview]) }
  def find_duplicates
    duplicates = MediaReview.find_duplicates(self.url, self.author["name"])
    duplicates.delete(self)
    duplicates
  end

  sig { returns(T::Boolean) }
  def start_scrape
    url = self.item_reviewed["contentUrl"]
    if url.nil?
      self.item_reviewed["mediaItemAppearance"].each do |appearance|
        object_model = ArchiveItem.model_for_url(appearance["accessedOnUrl"])
        unless object_model.nil?
          url = appearance["accessedOnUrl"]
          break
        end
      end
    end

    if url.nil?
      raise NoScraperForURL.new(url)
    end

    object_model = ArchiveItem.model_for_url(url)
    return false if object_model.nil?

    object_model.create_from_url(url, media_review: self) # Start scraping
    true
  end

  sig { returns(T::Boolean) }
  def orphaned?
    archive_item.nil?
  end

  sig { returns(Hash) }
  def render_for_export
    MediaReviewBlueprint.render_as_hash(self)
  end

  sig { returns(String) }
  def media_authenticity_category_humanized
    begin
      media_authenticity_categories = JSON.parse(self.media_authenticity_category)
    rescue JSON::ParserError
      media_authenticity_categories = [self.media_authenticity_category]
    end

    humanized_media_authenticity_categories = media_authenticity_categories.map do |media_authenticity_category|
      case media_authenticity_category
      when "DecontextualizedContent"
        "Missing Context"
      when "EditedOrCroppedContent"
        "Edited or Cropped"
      when "OriginalMediaContent"
        "Original"
      when "SatireOrParodyContent"
        "Satire or Parody"
      when "StagedContent"
        "Staged"
      when "TransformedContent"
        "Transformed"
      else
        media_authenticity_category # Return as is if we don't know it
      end
    end

    humanized_media_authenticity_categories.sort_by! { |e| e.downcase }
    humanized_media_authenticity_categories.join(", ")
  end

  # A class to indicate that a post url passed in is invalid
  class NoScraperForURL < StandardError
    def initialize(url)
      super("No scraper for url #{url}")
    end
  end
end
