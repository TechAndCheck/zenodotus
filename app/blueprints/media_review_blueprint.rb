class MediaReviewBlueprint < Blueprinter::Base
  identifier :id

  fields :url
  field :media_authenticity_category, name: :mediaAuthenticityCategory
  field :original_media_context_description, name: :originalMediaContextDescription
  field :original_media_link, name: :originalMediaLink

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
    if media_review.author.nil?
      {
        "@type": "",
        "name": "",
        "url": "",
      }
    else
      {
        "@type": media_review.author.dig("@type"),
        "name": media_review.author.dig("name"),
        "url": media_review.author.dig("url"),
      }
    end
  end

  field :item_reviewed, name: :itemReviewed do |media_review|
    media_item_appearances = media_review.item_reviewed["mediaItemAppearance"]
    rendered_media_item_apperances = media_item_appearances&.map do |apperance|
      {
        "@type": apperance["@type"],
        "startTime": apperance["startTime"],
        "endTime": apperance["endTime"],
      }
    end

    rendered_media_item_apperances ||= [] # So it's not nil

    {
      "@type": "MediaReviewItem",
      "contentUrl": media_review.media_url,
      "mediaItemAppearance": rendered_media_item_apperances
    }
  end
end
