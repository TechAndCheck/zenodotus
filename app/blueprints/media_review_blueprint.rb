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
      {
        "@type": "MediaReviewItem",
        "creator": {
          "@type": media_review.item_reviewed.dig("creator", "@type"),
          "name": media_review.item_reviewed.dig("creator", "name"),
          "url": media_review.item_reviewed.dig("creator", "url"),
        },
        "interpretedAsClaim": {
          "@type": media_review.item_reviewed.dig("interpretedAsClaim", "@type"),
          "description": media_review.item_reviewed.dig("interpretedAsClaim", "description"),
        },
        "mediaItemAppearance": media_review.item_reviewed.fetch("mediaItemAppearance", [])
      }
    end
end
