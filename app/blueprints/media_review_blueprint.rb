class MediaReviewBlueprint < Blueprinter::Base
  identifier :id

  fields :url
  field :media_authenticity_category, name: :mediaAuthenticityCategory
  field :original_media_context_description, name: :originalMediaContextDescription

  field :@context do |media_review|
    "https://schema.org"
  end

  field :@type do |media_review|
    "MediaReview"
  end

  field :date_published, name: :datePublished do |media_review|
    media_review.date_published.strftime("%Y-%m-%d")
  end

  field :originalMediaLink do |media_review|
    media_review.original_media_link
  end

  field :author do |media_review|
    {
      "@type": media_review.author.dig("@type"),
      "name": media_review.author.dig("name"),
      "url": media_review.author.dig("url"),
      "image": media_review.author.dig("image"),
      "sameAs": media_review.author.dig("sameAs"),
    }
  end

  field :item_reviewed, name: :itemReviewed do |media_review|
    mediaItemAppearances = media_review.item_reviewed["mediaItemAppearance"].map do |appearance|
      {
        "@type": appearance["@type"],
        "accessedOnUrl": media_review.media_link
      }
    end
    {
      "@type": "MediaReviewItem",
      "creator": {
        "@type": media_review.item_reviewed.dig("creator", "@type"),
        "name": media_review.item_reviewed.dig("creator", "name"),
        "url": media_review.item_reviewed.dig("creator", "url")
      },
      "startTime": media_review.item_reviewed.dig("startTime"),
      "endTime": media_review.item_reviewed.dig("endTime"),
      "interpretedAsClaim": {
        "@type": media_review.item_reviewed.dig("interpretedAsClaim", "@type"),
        "description": media_review.item_reviewed.dig("interpretedAsClaim", "description"),
      },
      "mediaItemAppearance": mediaItemAppearances
    }
  end
end
