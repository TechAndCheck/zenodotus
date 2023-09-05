require "test_helper"

class ClaimReviewTest < ActiveSupport::TestCase
  include Minitest::Hooks
  include ActiveJob::TestHelper

  test "claim review properly can turn appearances into an array" do
    random_number = rand(10000)
    claim_review = ClaimReview.create!(
      author: {
        "@type": "Organization",
        "name": "realfact_#{random_number}",
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
        "datePublished": "2021-01-30",
        "appearance": ["https://www.facebook.com/1314047423/videos/475912420875607/"]
      },
      review_rating: {
        "@type": "Rating",
        "alternateName": "False",
        "bestRating": "9",
        "ratingValue": "4",
      },
      url: "https://www.realfact.com/factchecks/2021/feb/03/starwars_#{random_number}"
    )

    assert claim_review.appearances.is_a?(Array)
    assert_equal ["https://www.facebook.com/1314047423/videos/475912420875607/"], claim_review.appearances

    claim_review.update!({
      item_reviewed: {
        "@type": "Claim",
        "name": "Claim name",
        "author": {
          "@type": "Person",
          "jobTitle": "On the internet",
          "name": "Viral image"
        },
        "datePublished": "2021-01-30",
        "appearance": [{ url: "https://www.facebook.com/1314047423/videos/475912420875607/" }]
      },
    })
    assert claim_review.appearances.is_a?(Array)
    assert_equal ["https://www.facebook.com/1314047423/videos/475912420875607/"], claim_review.appearances
  end

  test "claim review blueprinter output has required characteristics" do
    media_review = MediaReview.create!(media_authenticity_category: "fake",
                                       author: { "name": "a_name" },
                                       date_published: "2022-10-22",
                                       item_reviewed: { "param": "val" },
                                       url: "https://foobar.com")
    random_number = rand(10000)
    claim_review = ClaimReview.create!(
      author: {
        "@type": "Organization",
        "name": "realfact_#{random_number}",
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
      url: "https://www.realfact.com/factchecks/2021/feb/03/starwars_#{random_number}",
      media_review: media_review
    )

    expected = {
      "id" => claim_review.id,
      "url" => "https://www.realfact.com/factchecks/2021/feb/03/starwars_#{random_number}",
      "datePublished" => "2021-02-01",
      "claimReviewed" => "The approach will not be easy. You are required to maneuver straight down this trench and skim the surface to this point. The target area is only two meters wide.",
      "@context" => "https://schema.org",
      "@type" => "ClaimReview",
      "author" => {
        "@type" => "Organization",
        "name" => "realfact_#{random_number}",
        "url" => "https://www.realfact.com/",
      },
      "reviewRating" => {
        "@type" => "Rating",
        "alternateName" => "False",
        "bestRating" => "9",
        "ratingValue" => "4",
      },
      "itemReviewed" => {
        "@type" => "Claim",
        "name" => "Claim name",
        "author" => {
          "@type" => "Person",
          "jobTitle" => "On the internet",
          "name" => "Viral image",
        },
        "datePublished" => "2021-01-30"
      }
    }
    claim_review_json = JSON.parse(claim_review.render_for_export.to_json) # call blueprinter
    assert_equal expected, claim_review_json
  end

  test "can find duplicates" do
    # We're searching for one of the seeds
    assert_not ClaimReview.find_duplicates("The approach will not be easy. You are required to maneuver straight down this trench and skim the surface to this point. The target area is only two meters wide.", "https://www.realfact.com/factchecks/2021/feb/03/starwars", "realfact").empty?
  end

  test "duplicate raises error" do
    ClaimReview.create!(
      author: {
        "@type": "Organization",
        "name": "realfact_2",
        "url": "https://www.realfact.com/"
      },
      claim_reviewed: "The approach will not be easy, will it?. You are required to maneuver straight down this trench and skim the surface to this point. The target area is only two meters wide.",
      date_published: "2021-02-01",
      item_reviewed: {
        "@type": "Claim",
        "name": "Claim name",
        "author": {
          "@type": "Person",
          "jobTitle": "On the internet",
          "name": "Viral image"
        },
        "datePublished": "2021-01-30",
        "appearance": ["https://www.facebook.com/1314047423/videos/475912420875607/"]
      },
      review_rating: {
        "@type": "Rating",
        "alternateName": "False",
        "bestRating": "9",
        "ratingValue": "4",
      },
      url: "https://www.realfact.com/factchecks/2021/feb/03/starwars_2"
    )

    assert_raises do
      ClaimReview.create!(
        author: {
          "@type": "Organization",
          "name": "realfact_2",
          "url": "https://www.realfact.com/"
        },
        claim_reviewed: "The approach will not be easy, will it?. You are required to maneuver straight down this trench and skim the surface to this point. The target area is only two meters wide.",
        date_published: "2021-02-01",
        item_reviewed: {
          "@type": "Claim",
          "name": "Claim name",
          "author": {
            "@type": "Person",
            "jobTitle": "On the internet",
            "name": "Viral image"
          },
          "datePublished": "2021-01-30",
          "appearance": ["https://www.facebook.com/1314047423/videos/475912420875607/"]
        },
        review_rating: {
          "@type": "Rating",
          "alternateName": "False",
          "bestRating": "9",
          "ratingValue": "4",
        },
        url: "https://www.realfact.com/factchecks/2021/feb/03/starwars_2"
      )
    end
  end
end
