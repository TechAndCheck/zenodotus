require "test_helper"

class MediaReviewTest < ActiveSupport::TestCase
  include Minitest::Hooks
  include ActiveJob::TestHelper

  test "test_media_review_blueprinter_output_has_required_characteristics" do
    MediaReview.create!(media_authenticity_category: "fake",
                                       author: { "name": "a_name" },
                                       date_published: "2022-10-22",
                                       item_reviewed: { "param": "val" },
                                       url: "https://foobar.com")

    media_review = MediaReview.create!(
      original_media_link: "https://www.foobar.com/1",
      date_published: "2021-02-03",
      url: "https://www.realfact.com/factchecks/2021/feb/03/starwars",
      author: {
        "@type": "Organization",
        "name": "realfact",
        "url": "https://realfact.com"
      },
      media_authenticity_category: "TransformedContent",
      original_media_context_description: "Star Wars Ipsum",
      item_reviewed: {
        "@type": "MediaReviewItem",
        "creator": {
          "@type": "Person",
          "name": "Old Ben Kenobi",
          "url": "https://www.foobar.com/x/1"
        },
        "interpretedAsClaim": {
          "@type": "Claim",
          "description": "Two droids on the imperial watchlist entered a hovercraft"
        },
        "embeddedTextCaption": "Your droids. They’ll have to wait outside. We don’t want them here. Listen, why don’t you wait out by the speeder. We don’t want any trouble.",
        # "originalMediaLink": "https://www.foobar.com/1",
        "mediaItemAppearance": [
          {
            "@type": "ImageObjectSnapshot",
            "description": "A stormtrooper posted a screenshot of two droids entering a hovercraft",
            "sha256sum": ["8bb6caeb301b85cddc7b67745a635bcda939d17044d9bcf31158ef5e9f8ff072"],
            "accessedOnUrl": "https://www.facebook.com/photo.php?fbid=10217541425752089&set=a.1391489831857&type=3",
            "archivedAt": "https://archive.is/dfype"
          },
          {
            "@type": "ImageObjectSnapshot",
            "contentUrl": "https://www.foobar.com/1",
            "archivedAt": "www.archive.org"
          }
        ]
      }
    )

    media_review_json = JSON.parse(media_review.to_json)

    assert_not_nil media_review_json["id"]
    assert_not_nil media_review_json["url"]
    assert_not_nil media_review_json["datePublished"]
    assert_not_nil media_review_json["mediaAuthenticityCategory"]

    assert_not_nil media_review_json["author"]["name"]

    assert_not_nil media_review_json["itemReviewed"]["creator"]["name"]
    assert_not_nil media_review_json["itemReviewed"]["creator"]["url"]

    assert_not_nil media_review_json["itemReviewed"]["interpretedAsClaim"]["description"]
    assert media_review_json["itemReviewed"]["mediaItemAppearance"].length.positive?
  end
end
