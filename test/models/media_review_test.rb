require "test_helper"

class MediaReviewTest < ActiveSupport::TestCase
  include Minitest::Hooks
  include ActiveJob::TestHelper

  def before_all
    @@media_review_kwargs = {
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
    }
    @@expected = {
      "@context" => "https://schema.org",
      "@type" => "MediaReview",
      "id" => nil,
      "datePublished" => "2021-02-03",
      "url" => "https://www.realfact.com/factchecks/2021/feb/03/starwars",
      "author" => {
        "@type" => "Organization",
        "name" => "realfact",
        "url" => "https://realfact.com",
        "image" => nil,
        "sameAs" => nil
      },
      "mediaAuthenticityCategory" => "TransformedContent",
      "originalMediaContextDescription" => "Star Wars Ipsum",
      "itemReviewed" => {
        "@type" => "MediaReviewItem",
        "creator" => {
          "@type" => "Person",
          "name" => "Old Ben Kenobi",
          "url" => "https://www.foobar.com/x/1"
        },
        "interpretedAsClaim" => {
          "@type" => "Claim",
          "description" => "Two droids on the imperial watchlist entered a hovercraft"
        },
        "mediaItemAppearance" => [
          {
            "@type" => "ImageObjectSnapshot",
            "description" => "A stormtrooper posted a screenshot of two droids entering a hovercraft",
            "sha256sum" => ["8bb6caeb301b85cddc7b67745a635bcda939d17044d9bcf31158ef5e9f8ff072"],
            "accessedOnUrl" => "https://www.facebook.com/photo.php?fbid=10217541425752089&set=a.1391489831857&type=3",
            "archivedAt" => "https://archive.is/dfype"
          },
          {
            "@type" => "ImageObjectSnapshot",
            "contentUrl" => "https://www.foobar.com/1",
            "archivedAt" => "www.archive.org"
          }
        ]
      }
    }
  end

  test "media review blueprinter output has required characteristics" do
    media_review = MediaReview.create!(**@@media_review_kwargs)
    expected_copy = @@expected.deep_dup
    expected_copy["id"] = media_review.id

    media_review_json = JSON.parse(media_review.render_for_export) # call blueprinter
    assert_equal expected_copy, media_review_json
  end

  test "can serialize mediareview with empty mediaItemAppearance array" do
    kwargs_copy = @@media_review_kwargs.deep_dup
    kwargs_copy[:item_reviewed][:mediaItemAppearance] = []

    media_review = MediaReview.create!(**kwargs_copy)

    # should generate without raising an exception
    media_review.render_for_export
    media_review.to_comma
  end
end
