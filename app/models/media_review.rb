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
    self.media_review_author = FactCheckOrganization.find_by(host_name: host)
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

  # Extract the content URL from a MediaReview hash
  #
  # #TODO: REMOVET HIS
  sig { params(media_review_hash: Hash).returns(String) }
  def self.get_content_url(media_review_hash)
    appearance = media_review_hash["itemReviewed"]["mediaItemAppearance"].select do |appearance|
      appearance.key?("contentUrl")
    end.first

    appearance["contentUrl"]
  end

  # Create or update a MediaReview Record using the input hash
  sig { params(media_review_hash: Hash,
               external_unique_id: T.nilable(String), # We won't have a uuid when we scrape mediareview from pages
               should_update: T::Boolean
              ).returns(MediaReview) }
  def self.create_or_update_from_media_review_hash(media_review_hash, external_unique_id, should_update)
    original_media_link = media_review_hash.has_key?("originalMediaLink") ? media_review_hash["originalMediaLink"] : nil

    if should_update
      existing_media_review = MediaReview.where(external_unique_id: external_unique_id).first
      existing_media_review.update!(
        media_url: media_review_hash["itemReviewed"]["contentUrl"],
        original_media_link: original_media_link,
        media_authenticity_category: media_review_hash["mediaAuthenticityCategory"],
        original_media_context_description: media_review_hash["originalMediaContextDescription"],
        date_published: media_review_hash["datePublished"],
        url: media_review_hash["url"],
        author: media_review_hash["author"],
        item_reviewed: media_review_hash["itemReviewed"]
      )
      existing_media_review.reload
      existing_media_review
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

      mr
    end
  end

  sig { params(url: String, author_name: String).returns(T::Array[MediaReview]) }
  def self.find_duplicates(url, author_name)
    # We'll compare based on url, and author
    possible_duplicates = MediaReview.where(url: url)
    possible_duplicates.select do |possible_duplicate|
      possible_duplicate.author["name"] == author_name
    end
  end

  sig { returns(T::Boolean) }
  def scrape
    object_model = ArchiveItem.model_for_url(self.item_reviewed["contentUrl"])
    return false if object_model.nil?

    object_model.create_from_url(self.item_reviewed["contentUrl"]) # Start scraping
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
end
