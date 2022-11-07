require "test_helper"

class ClaimReviewTest < ActiveSupport::TestCase
  include Minitest::Hooks
  include ActiveJob::TestHelper

  test "claim review blueprinter output has required characteristics" do
    media_review = MediaReview.create!(media_authenticity_category: "fake",
                                       author: { "name": "a_name" },
                                       date_published: "2022-10-22",
                                       item_reviewed: { "param": "val" },
                                       url: "https://foobar.com")

    claim_review = ClaimReview.create!(
      author: {
        "@type": "Organization",
        "name": "realfact",
        "url": "https://www.realfact.com/"
      },
      claim_reviewed: "The approach will not be easy. You are required to maneuver straight down this trench and skim the surface to this point. The target area is only two meters wide.",
      date_published: "2021-02-01",
      item_reviewed: {
        "@type": "Claim",
        "name": "Claim name",
        "author": {
          "@type": "Person",
          "jobTitle": "On the internet",
          "name": "Viral image"
        },
        "datePublished": "2021-01-30"
      },
      review_rating: {
        "@type": "Rating",
        "alternateName": "False",
        "bestRating": "9",
        "ratingValue": "4",
      },
      url: "https://www.realfact.com/factchecks/2021/feb/03/starwars",
      media_review: media_review
    )

    expected = {
      "id" => claim_review.id,
      "url" => "https://www.realfact.com/factchecks/2021/feb/03/starwars",
      "datePublished" => "2021-02-01",
      "claimReviewed" => "The approach will not be easy. You are required to maneuver straight down this trench and skim the surface to this point. The target area is only two meters wide.",
      "@context" => "https://schema.org",
      "@type" => "ClaimReview",
      "author" => {
        "@type" => "Organization",
        "name" => "realfact",
        "url" => "https://www.realfact.com/",
        "image" => nil,
        "sameAs" => nil,
      },
      "reviewRating" => {
        "@type" => "Rating",
        "alternateName" => "False",
        "bestRating" => "9",
        "ratingValue" => "4",
        "image" => nil,
      },
      "itemReviewed" => {
        "@type" => "Claim",
        "name" => "Claim name",
        "author" => {
          "@type" => "Person",
          "jobTitle" => "On the internet",
          "name" => "Viral image",
          "image" => nil,
          "sameAs" => nil
        },
        "datePublished" => "2021-01-30"
      }
    }
    claim_review_json = JSON.parse(claim_review.render_for_export) # call blueprinter
    assert_equal expected, claim_review_json
  end

  test "can't create claim review without mediareview" do
    assert_raises ActiveRecord::RecordInvalid do
      ClaimReview.create!(
        author: {
          "@type": "Organization",
          "name": "realfact",
          "url": "https://www.realfact.com/"
        },
        claim_reviewed: "The approach will not be easy. You are required to maneuver straight down this trench and skim the surface to this point. The target area is only two meters wide.",
        date_published: "2021-02-01",
        item_reviewed: {
          "@type": "Claim",
          "author": {
            "@type": "Person",
            "jobTitle": "On the internet",
            "name": "Viral image"
          },
          "datePublished": "2021-01-30"
        },
        review_rating: {
          "@type": "Rating",
          "alternateName": "False",
          "bestRating": "9",
          "ratingValue": "4",
        },
        url: "https://www.realfact.com/factchecks/2021/feb/03/starwars",
      )
    end
  end
end
