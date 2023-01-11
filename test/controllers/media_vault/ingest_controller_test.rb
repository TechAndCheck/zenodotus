# typed: ignore

require "test_helper"

class MediaVault::IngestControllerTest < ActionDispatch::IntegrationTest
  include Minitest::Hooks

  def around
    AwsS3Downloader.stub(:download_file_in_s3_received_from_hypatia, S3_MOCK_STUB) do
      super
    end
  end

  setup do
    host! Figaro.env.MEDIA_VAULT_HOST

    @@media_review_json = {
      "@context": "https://schema.org",
      "@type": "MediaReview",
      "originalMediaContextDescription": "",
      "datePublished": "2020-11-09",
      "author": {
        "@type": "Organization",
        "name": "PolitiFact",
        "url": "http://www.politifact.com"
      },
      "mediaAuthenticityCategory": "Transformed",
      "itemReviewed": {
        "@type": "MediaReviewItem",
        "creator": {
          "@type": "Person",
          "name": "Viral image"
        },
        "interpretedAsClaim": {
          "@type": "Claim",
          "description": "The Washington Times ran a front-page headline that said, “President Gore.”"
        },
        "mediaItemAppearance": [{
          "@type": "ImageObject",
          "startTime": "",
          "endTime": "",
          "accessedOnUrl": "https://archive.is/dZOzm"
        }]
      },
      "associatedClaimReview": {
        "@context": "https://schema.org",
        "@type": "ClaimReview",
        "datePublished": "Mon, 09 Nov 2020 18:42:22 UTC +00:00",
        "url": "https://www.politifact.com/factchecks/2020/nov/09/viral-image/no-washington-times-didnt-run-president-gore-cover/",
        "author": {
          "@type": "Organization",
          "url": "http://www.politifact.com",
          "image": "https://d10r9aj6omusou.cloudfront.net/factstream-logo-image-61554e34-b525-4723-b7ae-d1860eaa2296.png",
          "name": "PolitiFact"
        },
        "claimReviewed": "The Washington Times ran a front-page headline that said, “President Gore.”",
        "reviewRating": {
          "@type": "Rating",
          "ratingValue": 4,
          "ratingExplanation": "",
          "bestRating": 0,
          "worstRating": 5,
          "image": "https://factstream-20220822-exp-9kewha.herokuapp.com/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBc2U5IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--803abd40cd5da803ee8271bcd61e8a3187843abb/https-3A-2F-2Fdhpikd1t89arn.cloudfront.net-2Frating_images-2Fpolitifact-2Ftom-false.jpg?disposition=attachment",
          "alternateName": "False"
        },
        "itemReviewed": {
          "@type": "CreativeWork",
          "author": {
            "@type": "Person",
            "name": "Viral image",
            "jobTitle": "On the internet",
            "image": "https://factstream-20220822-exp-9kewha.herokuapp.com/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBc2E5IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--c0b3158354a803a58de25855caa7861d6ebed9f7/ddc2d918-bfef-4bed-b77f-f6173ecafdc5.jpg?disposition=attachment"
          },
          "datePublished": "Sat, 07 Nov 2020",
          "appearance": [],
          "name": ""
        }
      },
      "originalMediaLink": "",
      "url":  "https://www.politifact.com/factchecks/2020/nov/09/viral-image/no-washington-times-didnt-run-president-gore-cover/"
    }.to_json

    @@claim_review_json = {
      "@context": "https://schema.org",
      "@type": "ClaimReview",
      "datePublished": "Wed, 11 Mar 2020 01:05:52 UTC +00:00",
      "url": "https://www.politifact.com/factchecks/2020/mar/10/facebook-posts/melanin-doesnt-protect-against-coronavirus/",
      "author": {
        "@type": "Organization",
        "url": "http://www.politifact.com",
        "image": "https://d10r9aj6omusou.cloudfront.net/factstream-logo-image-61554e34-b525-4723-b7ae-d1860eaa2296.png",
        "name": "PolitiFact"
      },
      "claimReviewed": "“People Of Color May Be Immune To The Coronavirus Because Of Melanin.",
      "reviewRating": {
        "@type": "Rating",
        "ratingValue": "4",
        "bestRating": "9",
        "image": "https://factstream-20220822-exp-9kewha.herokuapp.com/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBcnFpIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--12cd90f2b31e87291d47eaff4a12b9b4551fe5bd/https-3A-2F-2Fdhpikd1t89arn.cloudfront.net-2Frating_images-2Fpolitifact-2Ftom-false.jpg?disposition=attachment",
        "alternateName": "False"
      },
      "itemReviewed": {
        "@type": "CreativeWork",
        "author": {
          "@type": "Person",
          "name": "Facebook posts",
          "jobTitle": "Posters on Facebook and other social media networks",
          "image": "https://factstream-20220822-exp-9kewha.herokuapp.com/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBcm1pIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--917dd94a87cde5a65f77c27942c06679dc7256f0/https-3A-2F-2Fstatic.politifact.com-2FCACHE-2Fimages-2Fpolitifact-2Fmugs-2FFacebook_Logo_2019-2F0354d72cb90b5ac1c6c34a66f17d862e.jpg?disposition=attachment",
          "datePublished": "Sun, 23 Feb 2020"
        }
      }
    }.to_json
  end

  test "Submitting an API request without a key will return 401 error" do
    post media_vault_ingest_api_raw_path, params: { review_json: @@media_review_json, external_unique_id: SecureRandom.uuid }, as: :json
    assert_response 401
  end

  test "Submitting an API request with a wrong key will return 401 error" do
    post media_vault_ingest_api_raw_path, params: { review_json: @@media_review_json, external_unique_id: SecureRandom.uuid, api_key: "wrong password" }, as: :json
    assert_response 401
  end

  test "Submitting real JSON but with a bad schemas to the ingest API gives a 400" do
    post media_vault_ingest_api_raw_path, params: { review_json: { title: "Ahoy!" }.to_json, external_unique_id: SecureRandom.uuid, api_key: "123456789" }, as: :json
    assert_response 400

    json = nil
    assert_nothing_raised do
      json = JSON.parse(response.body)
    end

    assert_includes json.keys, "error_code"
    assert_includes json.keys, "error"
    assert_includes json.keys, "failures"

    assert_equal 11, json["error_code"]
    assert_equal "Error parsing JSON, JSON does not conform to schema", json["error"]
    # TODO: add information
  end

  test "Submitting invalid JSON to the ingest API gives a 400" do
    post media_vault_ingest_api_raw_path, params: { review_json: { title: "Ahoy!" }, external_unique_id: SecureRandom.uuid, api_key: "123456789" }, as: :json
    assert_response 400

    json = nil
    assert_nothing_raised do
      json = JSON.parse(response.body)
    end

    assert_includes json.keys, "error_code"
    assert_includes json.keys, "error"
    assert_includes json.keys, "failures"

    assert_equal 10, json["error_code"]
    assert_equal "Error parsing JSON, invalid JSON", json["error"]
    # TODO: add information
  end

  test "Can archive ClaimReview from json" do
    starting_claim_review_count = ClaimReview.count
    post media_vault_ingest_api_raw_path, params: { review_json: @@claim_review_json, external_unique_id: SecureRandom.uuid, api_key: "123456789" }, as: :json
    assert_response 200

    assert_equal starting_claim_review_count + 1, ClaimReview.count
  end

  test "Can archive MediaReview from json" do
    starting_media_review_count = MediaReview.count

    post media_vault_ingest_api_raw_path, params: { review_json: @@media_review_json, external_unique_id: SecureRandom.uuid, api_key: "123456789" }, as: :json
    assert_response 200

    assert_equal starting_media_review_count + 1, MediaReview.count
  end

  # NOTE: This is commented out until implementation fixes are completed which will come when we
  # implement webpage scrapers instead of just social media.
  ###################################################################################################
  # test "can archive MediaReview from a webpage" do
  #   post media_vault_ingest_api_url_path, params: { url: "https://oneroyalace.github.io/MediaReview-Fodder/single_embedded_media_review.html", external_unique_id: SecureRandom.uuid, api_key: "123456789" }
  #   assert_response 200

  #   json = nil
  #   assert_nothing_raised do
  #     json = JSON.parse(response.body)
  #   end

  #   assert_includes json.keys, "response_code"
  #   assert_includes json.keys, "response"

  #   assert_equal 20, json["response_code"]
  #   assert_equal "Successfully archived 1 MediaReview object(s) and associated media", json["response"]
  # end

  # test "can archive multiple MediaReview from a webpage" do
  #   post media_vault_ingest_api_url_path, params: { url: "https://oneroyalace.github.io/MediaReview-Fodder/multiple_embedded_media_review.html", external_unique_id: SecureRandom.uuid, api_key: "123456789" }
  #   assert_response 200

  #   json = nil
  #   assert_nothing_raised do
  #     json = JSON.parse(response.body)
  #   end

  #   assert_includes json.keys, "response_code"
  #   assert_includes json.keys, "response"

  #   assert_equal 20, json["response_code"]
  #   assert_equal "Successfully archived 2 MediaReview object(s) and associated media", json["response"]
  # end

  # test "return 400 if passed a url that points to a page with no MediaReview" do
  #   post media_vault_ingest_api_url_path, params: { url: "https://oneroyalace.github.io/MediaReview-Fodder/no_embedded_media_review.html", external_unique_id: SecureRandom.uuid, api_key: "123456789" }
  #   assert_response 400

  #   json = nil
  #   assert_nothing_raised do
  #     json = JSON.parse(response.body)
  #   end

  #   assert_includes json.keys, "response_code"
  #   assert_includes json.keys, "response"

  #   assert_equal 40, json["response_code"]
  #   assert_equal "Could not find MediaReview in webpage", json["response"]
  # end

  test "Submitting a MediaReview with a known external_unique_id updates the existing MediaReivew object" do
    # Ingest a MediaReview json
    common_uuid = SecureRandom.uuid
    post media_vault_ingest_api_raw_path, params: { review_json: @@media_review_json, external_unique_id: common_uuid, api_key: "123456789" }, as: :JSON

    # Attach the MediaReview to a dummy archive item
    dummy_archive_item = Sources::Tweet.create_from_url!("https://twitter.com/AmtrakNECAlerts/status/1397922363551870990")
    media_review_object = MediaReview.where(external_unique_id: common_uuid).first
    media_review_object.archive_item = dummy_archive_item
    media_review_object.save

    assert_equal "Transformed", media_review_object.media_authenticity_category

    # Ingest a MediaReview json with the same external_unique_id value
    modified_media_review_json = JSON.parse(@@media_review_json)
    modified_media_review_json["mediaAuthenticityCategory"] = "Not manipulated"
    post media_vault_ingest_api_raw_path, params: { review_json: modified_media_review_json.to_json, external_unique_id: common_uuid, api_key: "123456789" }, as: :json

    # Check that the old MediaReview object has been updated
    media_review_object.reload
    assert_equal "Not manipulated", media_review_object.media_authenticity_category
  end

  test "Submitting a ClaimReview with a known external_unique_id updates the existing ClaimReview object" do
    # Ingest a ClaimReview json
    common_uuid = SecureRandom.uuid
    post media_vault_ingest_api_raw_path, params: { review_json: @@claim_review_json, external_unique_id: common_uuid, api_key: "123456789" }, as: :JSON

    claim_review_object = ClaimReview.where(external_unique_id: common_uuid).first
    assert_equal "https://www.politifact.com/factchecks/2020/mar/10/facebook-posts/melanin-doesnt-protect-against-coronavirus/", claim_review_object.url

    # Ingest a MediaReview json with the same external_unique_id value
    modified_claim_review_json = JSON.parse(@@claim_review_json)
    modified_claim_review_json["url"] = "https://www.foobar.com/"
    post media_vault_ingest_api_raw_path, params: { review_json: modified_claim_review_json.to_json, external_unique_id: common_uuid, api_key: "123456789" }, as: :json

    # Check that the old MediaReview object has been updated
    claim_review_object.reload
    assert_equal "https://www.foobar.com/", claim_review_object.url
  end
end
