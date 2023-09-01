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
    to_return = {
      "contentUrl": media_review.media_url
    }

    mediaItemAppearance = media_review.item_reviewed["mediaItemAppearance"]
    unless mediaItemAppearance.blank?
      to_return["@type"] = mediaItemAppearance.first["@type"]
      to_return["startTime"] = mediaItemAppearance.first["startTime"]
      to_return["endTime"] = mediaItemAppearance.first["endTime"]
    end

    to_return
  end
end
