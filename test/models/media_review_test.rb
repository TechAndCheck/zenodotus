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
            "accessedOnUrl": "https://www.foobar.com/1",
            "archivedAt": "www.archive.org"
          }
        ]
      }
    }

    @@expected = {
                    "id": "d5c80c08-3f31-4e9c-93ed-e044e954e78a",
                    "@context": "https://schema.org",
                    "@type": "MediaReview",
                    "author": {
                      "@type": "Organization",
                      "name": "realfact",
                      "url": "https://realfact.com",
                      "image": nil,
                      "sameAs": nil
                    },
                    "datePublished": "2021-02-03",
                    "itemReviewed": {
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
                      "mediaItemAppearance": [{
                        "@type": "ImageObjectSnapshot",
                        "accessedOnUrl": "https://www.facebook.com/photo.php?fbid=10217541425752089&set=a.1391489831857&type=3",
                        "startTime": nil,
                        "endTime": nil
                      },
                      {
                        "@type": "ImageObjectSnapshot",
                        "accessedOnUrl": "https://www.foobar.com/1",
                        "startTime": nil,
                        "endTime": nil
                      }]
                    },
                    "mediaAuthenticityCategory": "TransformedContent",
                    "originalMediaContextDescription": "Star Wars Ipsum",
                    "originalMediaLink": "https://www.foobar.com/1",
                    "url": "https://www.realfact.com/factchecks/2021/feb/03/starwars"
                  }
  end

  # A note for this test: if we change/update the output for MediaReview this will break immediately
  # That's FINE, just fix it so that the output is generated is represented in `@@expected`.
  # The only trick is to make damn sure that the code is being outputted correctly. This test is here
  # otherwise to make sure that in the course of doing something else that the output breaks.
  #
  # Basically, if you're messing around with `media_review_blueprinter` and this breaks, then just fix
  # it up manually, if you haven't been in that file something went wrong and you should fix the regression.
  test "media review blueprinter output has required characteristics" do
    media_review = MediaReview.create!(**@@media_review_kwargs)
    expected_copy = @@expected.deep_dup
    expected_copy["id"] = media_review.id

    media_review_json = JSON.parse(media_review.render_for_export) # call blueprinter

    # Because of some weirdness in MiniTest sometimes the keys will be strings, some symbols.
    # When exporting to JSON in the end this won't matter, but here for comparison we need 'em all the same
    # So we jsonify and then dejsonify it (`stringify_keys` doesn't work because it doesn't do a deep
    # convert)
    expected_copy = JSON.parse(expected_copy.to_json)

    # When we create the media_review the id will necessarily differ because that's how ids work
    # so we'll remove them before comparing the rest of the hash
    expected_copy["id"] = ""
    media_review_json["id"] = ""
    assert_equal expected_copy, media_review_json.stringify_keys
  end

  # I'm not sure what this test is good for since we should always have a `mediaItemAppearance` field
  # since otherwise, what are we archiving? However, it was here and did catch a thing where
  # if there was more than one element in the array the blueprinter would break (which is actually
  # counter intuitive, but here we are), so I'm keeping it for now.
  test "can serialize mediareview with empty mediaItemAppearance array" do
    kwargs_copy = @@media_review_kwargs.deep_dup
    kwargs_copy[:item_reviewed][:mediaItemAppearance] = []

    media_review = MediaReview.create!(**kwargs_copy)

    # should generate without raising an exception
    media_review.render_for_export
    media_review.to_comma
  end

  test "can check if orphaned" do
    kwargs_copy = @@media_review_kwargs.deep_dup

    media_review = MediaReview.create!(**kwargs_copy)
    assert media_review.orphaned?
  end

  test "can get humanized media authenticity categories" do
    media_review = MediaReview.create!(**@@media_review_kwargs)
    assert_equal "Transformed", media_review.media_authenticity_category_humanized

    media_review_kwargs = @@media_review_kwargs
    media_review_kwargs[:media_authenticity_category] = [
      "DecontextualizedContent",
      "EditedOrCroppedContent",
      "OriginalMediaContent",
      "SatireOrParodyContent",
      "StagedContent",
      "TransformedContent",
    ]

    media_review = MediaReview.create!(**@@media_review_kwargs)

    assert_equal("Missing Context, Edited or Cropped, Original, Satire or Parody, Staged, Transformed", media_review.media_authenticity_category_humanized)
  end
end
