require "test_helper"

class MediaReviewTest < ActiveSupport::TestCase
  include Minitest::Hooks
  include ActiveJob::TestHelper

  def before_all
    @@media_review_kwargs = {
      "@context": "https://schema.org",
      "@type": "MediaReview",
      "originalMediaLink": "https://www.foobar.com/1",
      "datePublished": "2021-02-03",
      "url": "https://www.realfact.com/factchecks/2021/feb/03/starwars",
      "author": {
        "@type": "Organization",
        "name": "realfact",
        "url": "https://realfact.com"
      },
      "mediaAuthenticityCategory": "TransformedContent",
      "originalMediaContextDescription": "Star Wars Ipsum",
      "itemReviewed": {
        "@type": "MediaReviewItem",
        "creator": {
          "@type": "Person",
          "name": "Old Ben Kenobi",
          "url": "https://www.foobar.com/x/1"
        },
        "startTime": "00:42",
        "endTime": "00:43",
        "interpretedAsClaim": {
          "@type": "Claim",
          "description": "Two droids on the imperial watchlist entered a hovercraft"
        },
        "mediaItemAppearance": [
          {
            "@type": "ImageObjectSnapshot",
            "accessedOnUrl": "https://www.facebook.com/photo.php?fbid=10217541425752089&set=a.1391489831857&type=3",
          }
        ]
      }
    }.to_json

    @@expected = {
      "@context": "https://schema.org",
      "@type": "MediaReview",
      "id": nil,
      "datePublished": "2021-02-03",
      "originalMediaLink": "https://www.foobar.com/1",
      "url": "https://www.realfact.com/factchecks/2021/feb/03/starwars",
      "author": {
        "@type": "Organization",
        "name": "realfact",
        "url": "https://realfact.com",
        "image": nil,
        "sameAs": nil
      },
      "mediaAuthenticityCategory": "TransformedContent",
      "originalMediaContextDescription": "Star Wars Ipsum",
      "itemReviewed": {
        "@type": "MediaReviewItem",
        "creator": {
          "@type": "Person",
          "name": "Old Ben Kenobi",
          "url": "https://www.foobar.com/x/1"
        },
        "startTime": "00:42",
        "endTime": "00:43",
        "interpretedAsClaim": {
          "@type": "Claim",
          "description": "Two droids on the imperial watchlist entered a hovercraft"
        },
        "mediaItemAppearance": [
          {
            "@type": "ImageObjectSnapshot",
            "accessedOnUrl": "https://www.facebook.com/photo.php?fbid=10217541425752089&set=a.1391489831857&type=3"
          }
        ]
      }
    }.to_json
  end

  test "media review blueprinter output has required characteristics" do
    media_review_args = JSON.parse(@@media_review_kwargs)
    # The next function expects three arguments, but ** destructers... so we have to add this
    media_review = MediaReview.create_or_update_from_media_review_hash(media_review_args, "123455", true)
    media_review_json = JSON.parse(media_review.render_for_export) # call blueprinter

    expected_json = JSON.parse(@@expected)

    assert_equal media_review_json["@context"], expected_json["@context"]
    assert_equal media_review_json["datePublished"], expected_json["datePublished"]
    assert_equal media_review_json["originalMediaLink"], expected_json["originalMediaLink"]
    assert_equal media_review_json["url"], expected_json["url"]
    assert_equal media_review_json["author"], expected_json["author"]
    assert_equal media_review_json["mediaAuthenticityCategory"], expected_json["mediaAuthenticityCategory"]
    assert_equal media_review_json["originalMediaContextDescription"], expected_json["originalMediaContextDescription"]

    assert_equal media_review_json["itemReviewed"]["@type"], expected_json["itemReviewed"]["@type"]
    assert_equal media_review_json["itemReviewed"]["creator"], expected_json["itemReviewed"]["creator"]
    assert_equal media_review_json["itemReviewed"]["startTime"], expected_json["itemReviewed"]["startTime"]
    assert_equal media_review_json["itemReviewed"]["endTime"], expected_json["itemReviewed"]["endTime"]
    assert_equal media_review_json["itemReviewed"]["interpretedAsClaim"], expected_json["itemReviewed"]["interpretedAsClaim"]
    assert_equal media_review_json["itemReviewed"]["mediaItemAppearance"], expected_json["itemReviewed"]["mediaItemAppearance"]
  end

  test "can serialize mediareview with empty mediaItemAppearance array" do
    media_review_args = JSON.parse(@@media_review_kwargs)
    media_review_args["itemReviewed"]["mediaItemAppearance"] = []
    # The next function expects three arguments, but ** destructers... so we have to add this
    media_review = MediaReview.create_or_update_from_media_review_hash(media_review_args, "123455", true)

    # should generate without raising an exception
    media_review.render_for_export
    media_review.to_comma
  end
end
