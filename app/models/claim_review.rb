class ClaimReview < ApplicationRecord
  belongs_to :media_review, optional: true, class_name: "MediaReview"
  belongs_to :claim_review_author, optional: true, class_name: "ClaimReviewAuthor"

  include PgSearch::Model
  multisearchable against: [:claim_reviewed, :item_reviewed]

  before_validation do |claim_review|
    # Migrate the claim review JSONB to a model instead
    claim_review.author["author"] = claim_review.author["url"] if claim_review.author["name"].nil?

    # See if there's a ClaimReviewAuthor already
    self.claim_review_author = ClaimReviewAuthor.find_or_create_by(name: claim_review.author["name"], url: claim_review.author["url"])
  end

  before_create do |claim_review|
    # We're keeping the original JSONB for the moment, though that can probably be dropped later
    duplicates = ClaimReview.find_duplicates(claim_review.claim_reviewed, claim_review.url, claim_review.author["name"])
    if duplicates.any?
      raise "Duplicate ClaimReview found: #{duplicates.map(&:id)}"
    end
  end

  sig { params(claim_review_hash: Hash, external_unique_id: T.nilable(String), should_update: T::Boolean).returns(ClaimReview) }
  def self.create_or_update_from_claim_review_hash(claim_review_hash, external_unique_id, should_update)
    if should_update
      existing_claim_review = ClaimReview.where(external_unique_id: external_unique_id).first
      existing_claim_review.update!(
        date_published: claim_review_hash["datePublished"],
        url: claim_review_hash["url"],
        author: claim_review_hash["author"],
        claim_reviewed: claim_review_hash["claimReviewed"],
        review_rating: claim_review_hash["reviewRating"],
        item_reviewed: claim_review_hash["itemReviewed"],
      )
      existing_claim_review.reload
    else
      ClaimReview.create!(
        external_unique_id: external_unique_id,
        date_published: claim_review_hash["datePublished"],
        url: claim_review_hash["url"],
        author: claim_review_hash["author"],
        claim_reviewed: claim_review_hash["claimReviewed"],
        review_rating: claim_review_hash["reviewRating"],
        item_reviewed: claim_review_hash["itemReviewed"],
      )
    end
  end

  sig { params(claim_reviewed: String, url: String, author_name: T.nilable(String)).returns(T::Array[ClaimReview]) }
  def self.find_duplicates(claim_reviewed, url, author_name)
    # We'll compare based on claim_reviewed, url, and author
    possible_duplicates = ClaimReview.where(url: url, claim_reviewed: claim_reviewed)
    possible_duplicates.select do |possible_duplicate|
      possible_duplicate.author["name"] == author_name
    end
  end

  sig { returns(Hash) }
  def render_for_export
    ClaimReviewBlueprint.render_as_hash(self)
  end

  sig { returns T::Array[String] }
  def appearances
    return [] if self.item_reviewed["appearance"].nil?

    self.item_reviewed["appearance"]&.map do |appearance|
      appearance.is_a?(Hash) ? appearance["url"] : appearance
    end
  end
end
