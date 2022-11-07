# typed: strict

class MediaReview < ApplicationRecord
  belongs_to :archive_item, optional: true, class_name: "ArchiveItem"
  has_many :claim_reviews, foreign_key: :media_review_id, class_name: "ClaimReview", dependent: :destroy

  validates :author, presence: true
  validates :date_published, presence: true
  validates :item_reviewed, presence: true
  validates :media_authenticity_category, presence: true
  validates :url, presence: true

  # All media review without an attached piece of archive
  scope :orphaned, -> { where("archive_item_id = ?", nil) }

  # CSV export formatting
  comma do
    url "url"
    media_authenticity_category "mediaAuthenticityCategory"
    original_media_context_description "originalMediaContextDescription"
    date_published "datePublished" do |date_published| date_published.strftime("%Y-%m-%d") end
    __static_column__ "@context" do "https://schema.org" end
    __static_column__ "@type" do "MediaReview" end

    author "author_@type" do |author| author["@type"] end
    author "author_name" do |author| author["name"] end
    author "author_url" do |author| author["url"] end
    author "author_image" do |author| author["image"] end
    author "author_sameAs" do |author| author["sameAs"] end

    item_reviewed "itemReviewed_@type" do |item_reviewed| item_reviewed["@type"] end
    item_reviewed "itemReviewed_creator_@type" do |item_reviewed| item_reviewed.dig("creator", "@type") end
    item_reviewed "itemReviewed_creator_name" do |item_reviewed| item_reviewed.dig("creator", "name") end
    item_reviewed "itemReviewed_creator_url" do |item_reviewed| item_reviewed.dig("creator", "url") end
    item_reviewed "itemReviewed_interpretedAsClaim_@type" do |item_reviewed| item_reviewed.dig("interpretedAsClaim", "@type") end
    item_reviewed "itemReviewed_interpretedAsClaim_description" do |item_reviewed| item_reviewed.dig("interpretedAsClaim", "description") end


    # The CSV representation of a MediaReview will only include a single object from the mediaItemAppearance array
    # Namely, the object containing the `contentUrl` attribute
    # If the mediaItemAppearance array is nil or empty, we'll return null values for all related attributes in the CSV
    item_reviewed "itemReviewed_mediaItemAppearance_@type" do |item_reviewed|
      if !item_reviewed.has_key?("mediaItemAppearance") || item_reviewed["mediaItemAppearance"].empty?
        nil
      else
        appearance = item_reviewed.fetch("mediaItemAppearance", []).filter { |appearance| appearance.has_key?("contentUrl") }.first
        appearance["@type"]
      end
    end

    item_reviewed "itemReviewed_mediaItemAppearance_contentUrl" do |item_reviewed|
      if !item_reviewed.has_key?("mediaItemAppearance") || item_reviewed["mediaItemAppearance"].empty?
        nil
      else
        appearance = item_reviewed.fetch("mediaItemAppearance", []).filter { |appearance| appearance.has_key?("contentUrl") }.first
        appearance["contentUrl"]
      end
    end

    item_reviewed "itemReviewed_mediaItemAppearance_archivedAt" do |item_reviewed|
      if !item_reviewed.has_key?("mediaItemAppearance") || item_reviewed["mediaItemAppearance"].empty?
        nil
      else
        appearance = item_reviewed.fetch("mediaItemAppearance", []).filter { |appearance| appearance.has_key?("contentUrl") }.first
        appearance["archivedAt"]
      end
    end
  end

  sig { returns(Boolean) }
  def orphaned?
    archive_item.nil?
  end

  sig { returns(String) }
  def render_for_export
    MediaReviewBlueprint.render(self)
  end
end
