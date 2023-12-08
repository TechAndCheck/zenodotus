class ClaimReview < ApplicationRecord
  belongs_to :media_review, optional: true, class_name: "MediaReview"
  belongs_to :claim_review_author, optional: true, class_name: "FactCheckOrganization"

  include PgSearch::Model
  multisearchable against: [:claim_reviewed, :item_reviewed]

  # Everything says not to use default_scopes, but in this case I think it's appropriate because we
  # actually really really really only want to show confirmed claim_reviews.
  default_scope { where.not(claim_review_author: nil) }

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

  sig { returns(Array) }
  def self.csv_headers
    headers = [
      "id", "@context", "@type", "claimReviewed", "datePublished", "url", "author.@type",
      "author.name", "author.url", "itemReviewed.@type", "itemReviewed.author.name", "itemReviewed.author.@type",
      "itemReviewed.author.sameAs", "reviewRating.@type", "reviewRating.ratingValue", "reviewRating.alternateName",
      "author.image", "itemReviewed.name", "itemReviewed.datePublished", "itemReviewed.firstAppearance.url",
      "itemReviewed.firstAppearance.type", "itemReviewed.author.image", "reviewRating.ratingExplanation",
      "itemReviewed.author.jobTitle", "reviewRating.bestRating", "reviewRating.worstRating", "reviewRating.image"]

    headers += (1..15).map do |i|
      ["itemReviewed.appearance.#{i}.url",
        "itemReviewed.appearance.#{i}.@type"]
    end

    headers.flatten
  end

  sig { returns Array }
  def render_to_csv_line
    # Prep the structure so the output is correct
    item_reviewed = self.item_reviewed.nil? ? { "author": {}, "appearance": [], "reviewRating": {} }.transform_keys(&:to_s) : self.item_reviewed
    item_reviewed["author"] = {} if item_reviewed["author"].nil?
    item_reviewed["firstAppearance"] = {} if item_reviewed["firstAppearance"].nil?
    review_rating = self.review_rating.nil? ? {} : self.review_rating

    # Fix formatting... again
    if item_reviewed["firstAppearance"].is_a?(Array)
      if !item_reviewed["firstAppearance"].empty?
        item_reviewed["firstAppearance"] = item_reviewed["firstAppearance"].first
      else
        item_reviewed["firstAppearance"] = {}
      end
    elsif item_reviewed["firstAppearance"].is_a?(String)
      item_reviewed["firstAppearance"] = { "url": item_reviewed["firstAppearance"], "@type": "CreativeWork" }
    end

    # Hard code @type for first appearance if it exists
    item_reviewed["firstAppearance"]["@type"] = "CreativeWork" if item_reviewed["firstAppearance"].has_key?("url")

    # Create the input array
    line = ["#{self.id}", "https://schema.org", "ClaimReview", "#{self.claim_reviewed}",
      "#{self.date_published}", "#{self.url}", "#{self.author["@type"]}",
      "#{self.author["name"]}", "#{self.author["url"]}", "#{item_reviewed["@type"]}", "#{item_reviewed["author"]["name"]}",
      "#{item_reviewed["author"]["@type"]}", "#{item_reviewed["author"]["sameAs"]}", "#{review_rating["@type"]}",
      "#{review_rating["ratingValue"]}", "#{review_rating["alternateName"]}", "#{self.author["image"]}",
      "#{item_reviewed["name"]}", "#{item_reviewed["datePublished"]}", "#{item_reviewed["firstAppearance"]["url"]}",
      "#{item_reviewed["firstAppearance"]["@type"]}", "#{item_reviewed["author"]["image"]}",
      "#{review_rating["ratingExplanation"]}", "#{item_reviewed["author"]["jobTitle"]}", "#{review_rating["bestRating"]}",
      "#{review_rating["worstRating"]}", "#{review_rating["image"]}"]

    line += (1..15).map do |i|
      next if item_reviewed["appearance"].nil?
      if item_reviewed["appearance"].first.is_a?(Array)
        next if item_reviewed["appearance"][i - 1].nil?
        [item_reviewed["appearance"][i - 1]["url"],
         "CreativeWork"]
      elsif item_reviewed["appearance"].first.is_a?(String)
        [item_reviewed["appearance"], "CreativeWork"]
      else
        []
      end
    end

    line.flatten
  rescue StandardError => e
    Honeybadger.notify(e, context: { claimReview: self.inspect })
    []
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
