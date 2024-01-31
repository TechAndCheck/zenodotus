require "test_helper"

class ClaimReviewTest < ActiveSupport::TestCase
  include Minitest::Hooks
  include ActiveJob::TestHelper

  test "claim review properly can turn appearances into an array" do
    random_number = rand(10000)
    fco = FactCheckOrganization.create(name: "realfact_#{random_number}", url: "https://www.realfact.com/")

    claim_review = ClaimReview.create!(
      author: {
        "@type": "Organization",
        "name": "realfact_#{random_number}",
        "url": "https://www.realfact.com/"
      },
      claim_review_author: fco,
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
    random_number = rand(10000)
    fco = FactCheckOrganization.create(name: "realfact_#{random_number}", url: "https://www.realfact.com/")

    media_review = MediaReview.create!(media_authenticity_category: "fake",
                                       author: { "name": "realfact_#{random_number}", url: "https://www.realfact.com/" },
                                       date_published: "2022-10-22",
                                       item_reviewed: { "param": "val" },
                                       url: "https://foobar.com")

    claim_review = ClaimReview.create!(
      author: {
        "@type": "Organization",
        "name": "realfact_#{random_number}",
        "url": "https://www.realfact.com/"
      },
      claim_review_author: fco,
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

  test "does not create fact_check_organization when one is already created" do
    random_number = rand(10000)
    fco = FactCheckOrganization.create(name: "realfact_#{random_number}", url: "https://www.realfact.com/")

    assert_no_difference("FactCheckOrganization.count") do
      media_review = MediaReview.create!(media_authenticity_category: "fake",
                                         author: { "name": "realfact_#{random_number}", url: "https://www.realfact.com/" },
                                         date_published: "2022-10-22",
                                         item_reviewed: { "param": "val" },
                                         url: "https://foobar.com")
      ClaimReview.create!(
        author: {
          "@type": "Organization",
          "name": "realfact_#{random_number}",
          "url": "https://www.realfact.com/"
        },
        claim_review_author: fco,
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
    end
  end

  test "does not create claim_review if the organization is not in our list" do
    random_number = rand(10000)
    fco = FactCheckOrganization.create(name: "name", url: "https://www.realfactfake.com/")

    media_review = MediaReview.create!(media_authenticity_category: "fake",
                                       author: { "name": "name", url: "https://www.realfactfake.com/" },
                                       date_published: "2022-10-22",
                                       item_reviewed: { "param": "val" },
                                       url: "https://foobar.com")
    cr = ClaimReview.create(
      author: {
        "@type": "Organization",
        "name": "realfact_#{random_number}",
        "url": "https://www.realfact.com/"
      },
      claim_review_author: fco,
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

    assert_predicate cr.errors, :any?
  end
  test "can find duplicates" do
    # We're searching for one of the seeds
    random_number = rand(10000)
    fco = FactCheckOrganization.create(name: "realfact_#{random_number}", url: "https://www.realfact.com/")

    media_review = MediaReview.create!(media_authenticity_category: "fake",
                                       author: { "name": "realfact_#{random_number}", url: "https://www.realfact.com/" },
                                       media_review_author: fco,
                                       date_published: "2022-10-22",
                                       item_reviewed: { "param": "val" },
                                       url: "https://foobar.com")
    ClaimReview.create!(
      author: {
        "@type": "Organization",
        "name": "realfact_#{random_number}",
        "url": "https://www.realfact.com/"
      },
      claim_review_author: fco,
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

    assert_not ClaimReview.find_duplicates("The approach will not be easy. You are required to maneuver straight down this trench and skim the surface to this point. The target area is only two meters wide.", "https://www.realfact.com/factchecks/2021/feb/03/starwars_#{random_number}", "realfact_#{random_number}").empty?
  end

  test "can find duplicate with missing elements" do
    # For reference:
    # json = {
    #   "@context": "http://schema.org",
    #   "@type": "ClaimReview",
    #   "author": {
    #     "@type": "Organization",
    #     "url": "https://srilanka.factcrescendo.com/"
    #   },
    #   "claimReviewed": "කාන්තාරයක තිබූ එක් ගසක් කපා දැමීම වළකාලමින් ඉදි කළ මාර්ගයක ඡායාරූපයක් ද?",
    #   "itemReviewed": {
    #     "@type": "Claim",
    #     "appearance": [{
    #       "@type": "CreativeWork",
    #       "url": "https://tinyurl.com/26krkebo"
    #     }],
    #     "author": {
    #       "@type": "Person",
    #       "name": "Social Media Users"
    #     },
    #     "datePublished": "2023-08-18"
    #   },
    #   "reviewRating": {
    #     "@type": "Rating",
    #     "alternateName": "Misleading"
    #   },
    #   "sdPublisher": {
    #     "@type": "Organization",
    #     "name": "Google Fact Check Tools",
    #     "url": "https://g.co/factchecktools"
    #   },
    #   "url": "https://srilanka.factcrescendo.com/2023/08/21/digitally-manipulated-image-for-environmental-conservation-campaign-being-shared-as-true-in-sri-lanka/"
    # }.to_json

    assert_nothing_raised do
      ClaimReview.find_duplicates("කාන්තාරයක තිබූ එක් ගසක් කපා දැමීම වළකාලමින් ඉදි කළ මාර්ගයක ඡායාරූපයක් ද?", "https://tinyurl.com/26krkebo", nil)
    end
  end

  test "duplicate raises error" do
    fco = FactCheckOrganization.create(name: "realfact_2", url: "https://www.realfact.com/")

    ClaimReview.create!(
      author: {
        "@type": "Organization",
        "name": "realfact_2",
        "url": "https://www.realfact.com/"
      },
      claim_review_author: fco,
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
      fco = FactCheckOrganization.create(name: "realfact_2", url: "https://www.realfact.com/")

      ClaimReview.create!(
        author: {
          "@type": "Organization",
          "name": "realfact_2",
          "url": "https://www.realfact.com/"
        },
        claim_review_author: fco,
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
