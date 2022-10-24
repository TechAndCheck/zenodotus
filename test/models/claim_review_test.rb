require "test_helper"

class ClaimReviewTest < ActiveSupport::TestCase
  include Minitest::Hooks
  include ActiveJob::TestHelper

  test "test_claim_review_blueprinter_output_has_required_characteristics" do
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
        "worstRating": "0"
      },
      url: "https://www.realfact.com/factchecks/2021/feb/03/starwars",
      media_review: media_review
    )

    claim_review_json = JSON.parse(claim_review.to_json) # call blueprinter

    assert_not_nil claim_review_json["id"]
    assert_not_nil claim_review_json["url"]
    assert_not_nil claim_review_json["datePublished"]
    assert_not_nil claim_review_json["claimReviewed"]
    assert_not_nil claim_review_json["@type"]
    assert_not_nil claim_review_json["@context"]

    # Check that author is a Person (has name) or Organization (has url)
    assert_not_nil claim_review_json["author"]["name"] || claim_review_json["author"]["url"]

    assert_not_nil claim_review_json["reviewRating"]["ratingValue"]
    assert_not_nil claim_review_json["reviewRating"]["bestRating"]
    assert claim_review_json["reviewRating"].has_key?("image")
    assert claim_review_json["reviewRating"].has_key?("alternateName")

    assert_not_nil claim_review_json["itemReviewed"]["datePublished"]
    assert_not_nil claim_review_json["itemReviewed"]["author"]["name"]
    assert_not_nil claim_review_json["itemReviewed"]["author"]["jobTitle"]
    assert claim_review_json["itemReviewed"]["author"].has_key?("image")
    assert claim_review_json["itemReviewed"]["author"].has_key?("sameAs")
  end

  test "cant_create_claim_review_without_mediareview" do
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
          "worstRating": "0"
        },
        url: "https://www.realfact.com/factchecks/2021/feb/03/starwars",
      )
    end
  end
end
