class ClaimReview < ApplicationRecord
  belongs_to :media_review, optional: true, class_name: "MediaReview"

  include PgSearch::Model
  multisearchable against: [:claim_reviewed, :item_reviewed]

  # CSV export formatting
  comma do
    url "url"
    claim_reviewed "claimReviewed"
    date_published "datePublished" do |date_published| date_published.strftime("%Y-%m-%d") end
    __static_column__ "@context" do "https://schema.org" end
    __static_column__ "@type" do "ClaimReview" end

    author "author_@type" do |author| author["@type"] end
    author "author_name" do |author| author["name"] end
    author "author_url" do |author| author["url"] end
    author "author_image" do |author| author["image"] end
    author "author_sameAs" do |author| author["sameAs"] end

    review_rating "reviewRating_@type" do |review_rating| review_rating["@type"] end
    review_rating "reviewRating_ratingValue" do |review_rating| review_rating["ratingValue"] end
    review_rating "reviewRating_ratingExplanation" do |review_rating| review_rating["ratingExplanation"] end
    review_rating "reviewRating_bestRating" do |review_rating| review_rating["bestRating"] end
    review_rating "reviewRating_worstRating" do |review_rating| review_rating["worstRating"] end
    review_rating "reviewRating_image" do |review_rating| review_rating["image"] end
    review_rating "reviewRating_alternateName" do |review_rating| review_rating["alternateName"] end

    item_reviewed "itemReviewed_firstAppearance_@type" do |item_reviewed| item_reviewed.dig("appearance", 0, "@type") end
    item_reviewed "itemReviewed_firstAppearance_url" do |item_reviewed| item_reviewed.dig("appearance", 0, "url") end
    item_reviewed "itemReviewed_@type" do |item_reviewed| item_reviewed["@type"] end
    item_reviewed "itemReviewed_datePublished" do |item_reviewed| item_reviewed["datePublished"] end
    item_reviewed "itemReviewed_name" do |item_reviewed| item_reviewed["name"] end
    item_reviewed "itemReviewed_author_@type" do |item_reviewed| item_reviewed.dig("author", "@type") end
    item_reviewed "itemReviewed_author_name" do |item_reviewed| item_reviewed.dig("author", "name") end
    item_reviewed "itemReviewed_author_jobTitle" do |item_reviewed| item_reviewed.dig("author", "jobTitle") end
    item_reviewed "itemReviewed_author_image" do |item_reviewed| item_reviewed.dig("author", "image") end
    item_reviewed "itemReviewed_author_sameAs" do |item_reviewed| item_reviewed.dig("author", "sameAs") end
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

  sig { returns(String) }
  def render_for_export
    ClaimReviewBlueprint.render(self)
  end
end
