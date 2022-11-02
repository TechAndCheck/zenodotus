class ClaimReview < ApplicationRecord
  validates :media_review_id, presence: true
  belongs_to :media_review, optional: true, class_name: "MediaReview"

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
    review_rating "reviewRating_bestRating" do |review_rating| review_rating["bestRating"] end
    review_rating "reviewRating_image" do |review_rating| review_rating["image"] end
    review_rating "reviewRating_alternateName" do |review_rating| review_rating["alternateName"] end

    item_reviewed "itemReviewed_@type" do |item_reviewed| item_reviewed["@type"] end
    item_reviewed "itemReviewed_datePublished" do |item_reviewed| item_reviewed["datePublished"] end
    item_reviewed "itemReviewed_name" do |item_reviewed| item_reviewed["name"] end
    item_reviewed "itemReviewed_author_@type" do |item_reviewed| item_reviewed.dig("author", "@type") end
    item_reviewed "itemReviewed_author_name" do |item_reviewed| item_reviewed.dig("author", "name") end
    item_reviewed "itemReviewed_author_jobTitle" do |item_reviewed| item_reviewed.dig("author", "jobTitle") end
    item_reviewed "itemReviewed_author_image" do |item_reviewed| item_reviewed.dig("author", "image") end
    item_reviewed "itemReviewed_author_sameAs" do |item_reviewed| item_reviewed.dig("author", "sameAs") end
  end

  sig { returns(String) }
  def render_for_export
    ClaimReviewBlueprint.render(self)
  end
end
