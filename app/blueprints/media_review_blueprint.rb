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

    # If something is pulled from Google we have to massage the data to one way, FactStream from another way
    # NOTE: ADD TESTS FOR THIS
    if media_review.item_reviewed.has_key?("mediaItemAppearance")
      # FactStream
      mediaItemAppearance = media_review.item_reviewed["mediaItemAppearance"]
      unless mediaItemAppearance.blank?
        to_return["@type"] = mediaItemAppearance.first["@type"]
        to_return["startTime"] = mediaItemAppearance.first["startTime"]
        to_return["endTime"] = mediaItemAppearance.first["endTime"]
      end
    else
      # Google
      to_return["startTime"] = media_review.item_reviewed["startTime"] unless media_review.item_reviewed["startTime"].blank?
      to_return["endTime"] = media_review.item_reviewed["endTime"] unless media_review.item_reviewed["endTime"].blank?
      to_return["@type"] = media_review.item_reviewed["@type"] unless media_review.item_reviewed["@type"].blank?
    end

    to_return
  end
end
