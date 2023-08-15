class ClaimReviewBlueprint < Blueprinter::Base
  identifier :id

  fields :url
  field :claim_reviewed, name: :claimReviewed

  field :@context do |claim_review|
    "https://schema.org"
  end

  field :@type do |claim_review|
    "ClaimReview"
  end

  field :date_published, name: :datePublished do |claim_review|
    claim_review.date_published.nil? ? "" : claim_review.date_published.strftime("%Y-%m-%d")
  end

  field :author do |claim_review|
    if claim_review.author.nil?
      {
        "@type": "",
        "name": "",
        "url": "",
        "image": "",
        "sameAs": ""
      }
    else
      {
        "@type": claim_review.author.dig("@type"),
        "name": claim_review.author.dig("name"),
        "url": claim_review.author.dig("url"),
        "image": claim_review.author.dig("image"),
        "sameAs": claim_review.author.dig("sameAs"),
      }
    end
  end

  field :review_rating, name: :reviewRating do |claim_review|
    if claim_review.review_rating.nil?
      {
        "@type": "",
        "ratingValue": "",
        "bestRating": "",
        "worstRating": "",
        "ratingExplanation": "",
        "image": "",
        "alternateName": "",
      }
    else
      {
        "@type": claim_review.review_rating.dig("@type"),
        "ratingValue": claim_review.review_rating.dig("ratingValue"),
        "bestRating": claim_review.review_rating.dig("bestRating"),
        "worstRating": claim_review.review_rating.dig("worstRating"),
        "ratingExplanation": claim_review.review_rating.dig("ratingExplanation"),
        "image": claim_review.review_rating.dig("image"),
        "alternateName": claim_review.review_rating.dig("alternateName"),
      }
    end
  end

  field :item_reviewed, name: :itemReviewed do |claim_review|
    if claim_review.item_reviewed.nil?
      {
        "@type": "",
        "datePublished": "",
        "name": "",
        "appearance": "",
        "firstAppearance": "",
        "author": {
          "@type": "",
          "name": "",
          "jobTitle": "",
          "image": "",
          "sameAs": "",
        }
      }
    else
      {
        "@type": claim_review.item_reviewed.dig("@type"),
        "datePublished": claim_review.item_reviewed.dig("datePublished"),
        "name": claim_review.item_reviewed.dig("name"),
        "appearance": claim_review.item_reviewed.dig("appearance"),
        "firstAppearance": claim_review.item_reviewed.dig("appearance", 0),
        "author": {
          "@type": claim_review.item_reviewed.dig("author", "@type"),
          "name": claim_review.item_reviewed.dig("author", "name"),
          "jobTitle": claim_review.item_reviewed.dig("author", "jobTitle"),
          "image": claim_review.item_reviewed.dig("author", "image"),
          "sameAs": claim_review.item_reviewed.dig("sameAs")
        }
      }
    end
  end
end
