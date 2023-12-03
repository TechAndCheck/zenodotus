class ClaimReview < ApplicationRecord
  belongs_to :media_review, optional: true, class_name: "MediaReview"
  belongs_to :claim_review_author, optional: true, class_name: "FactCheckOrganization"

  include PgSearch::Model
  multisearchable against: [:claim_reviewed, :item_reviewed]

  validate :claim_review_author_must_be_recognized

  before_validation do |claim_review|
    # See if there's a ClaimReviewAuthor already
    begin
      host = URI.parse(claim_review.author["url"]).host
    rescue URI::InvalidURIError
      host = URI.parse("https://#{claim_review.author["url"]}").host
    end

    # Adjust so we add `www` to the front of a bare host
    adjusted_host = "www.#{host}" if host.split(".").count == 2

    matching_hosts = FactCheckOrganization.where(host_name: [host, adjusted_host]).order(:name)
    self.claim_review_author = matching_hosts.first unless matching_hosts.empty?
  end

  def claim_review_author_must_be_recognized
    # Make sure that the author is included in our list of FactCheckOrganizations
    if self.claim_review_author.nil?
      errors.add(:claim_review_author, "must be created by a recognized Fact Check Organization")
    end
  end

  before_create do |claim_review|
    # We're keeping the original JSONB for the moment, though that can probably be dropped later
    duplicates = ClaimReview.find_duplicates(claim_review.claim_reviewed, claim_review.url, claim_review.author["name"])
    if duplicates.any?
      raise ClaimReview::DuplicateError.new("Duplicate ClaimReview found: #{duplicates.map(&:id)}")
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

  sig { returns(T::Array[ClaimReview]) }
  def find_duplicates
    duplicates = ClaimReview.find_duplicates(self.claim_reviewed, self.url, self.author["name"])
    duplicates.delete(self)
    duplicates
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

  class DuplicateError < StandardError; end
end
