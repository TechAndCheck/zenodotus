# typed: ignore

require "test_helper"

class MediaVault::IngestControllerTest < ActionDispatch::IntegrationTest
  setup do
    host! Figaro.env.MEDIA_VAULT_HOST

    @@media_review_json = {
      "@context": "https://schema.org",
      "@type": "MediaReview",
      "datePublished": "2020-05-22",
      "author": {
        "@type": "Organization",
        "name": "PolitiFact",
        "url": "http://www.politifact.com"
      },
      "mediaAuthenticityCategory": "manipulated",
      "originalMediaContextDescription": "",
      "itemReviewed": {
        "@type": "MediaReviewItem",
        "creator": {
          "@type": "Person",
          "name": "Viral image",
          "url": "https://www.facebook.com/photo.php?fbid=10218894279041970&set=a.10202838682462090&type=3&theater"
        },
        "interpretedAsClaim": {
          "@type": "Claim",
          "description": "“If you have had a flu shot in the last 3-5 years, you will probably test positive” for COVID-19."
        },
        "mediaItemAppearance": [{
          "@type": "ImageObject",
           "description": "",
           "contentUrl": "https://www.facebook.com/photo.php?fbid=10218894279041970&set=a.10202838682462090&type=3&theater"
         }]
      },
      "url": "https://www.politifact.com/factchecks/2020/may/21/viral-image/flu-shots-arent-causing-false-positive-covid-19-te/"
    }.to_json
  end

  test "Submitting an API request without a key will return 401 error" do
    post media_vault_ingest_api_raw_path, params: { media_review_json: @@media_review_json }, as: :json
    assert_response 401
  end

  test "Submitting an API request with a wrong key will return 401 error" do
    post media_vault_ingest_api_raw_path, params: { media_review_json: @@media_review_json, api_key: "wrong password" }, as: :json
    assert_response 401
  end

  test "Submitting real JSON but with a bad schemas to the ingest API gives a 400" do
    post media_vault_ingest_api_raw_path, params: { media_review_json: { title: "Ahoy!" }.to_json, api_key: "123456789" }, as: :json
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
    post media_vault_ingest_api_raw_path, params: { media_review_json: { title: "Ahoy!" }, api_key: "123456789" }, as: :json
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

  test "Can archive media review from json" do
    post media_vault_ingest_api_raw_path, params: { media_review_json: @@media_review_json, api_key: "123456789" }, as: :json
    assert_response 200
  end

  test "can archive MediaReview from a webpage" do
    post media_vault_ingest_api_url_path, params: { url: "https://oneroyalace.github.io/MediaReview-Fodder/single_embedded_media_review.html", api_key: "123456789" }
    assert_response 200

    json = nil
    assert_nothing_raised do
      json = JSON.parse(response.body)
    end

    assert_includes json.keys, "response_code"
    assert_includes json.keys, "response"

    assert_equal 20, json["response_code"]
    assert_equal "Successfully archived 1 MediaReview object(s) and associated media", json["response"]
  end

  test "can archive multiple MediaReview from a webpage" do
    post media_vault_ingest_api_url_path, params: { url: "https://oneroyalace.github.io/MediaReview-Fodder/multiple_embedded_media_review.html", api_key: "123456789" }
    assert_response 200

    json = nil
    assert_nothing_raised do
      json = JSON.parse(response.body)
    end

    assert_includes json.keys, "response_code"
    assert_includes json.keys, "response"

    assert_equal 20, json["response_code"]
    assert_equal "Successfully archived 2 MediaReview object(s) and associated media", json["response"]
  end

  test "return 400 if passed a url that points to a page with no MediaReview" do
    post media_vault_ingest_api_url_path, params: { url: "https://oneroyalace.github.io/MediaReview-Fodder/no_embedded_media_review.html", api_key: "123456789" }
    assert_response 400

    json = nil
    assert_nothing_raised do
      json = JSON.parse(response.body)
    end

    assert_includes json.keys, "response_code"
    assert_includes json.keys, "response"

    assert_equal 40, json["response_code"]
    assert_equal "Could not find MediaReview in webpage", json["response"]
  end
end
