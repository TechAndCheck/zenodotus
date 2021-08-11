# typed: ignore

require "test_helper"

class IngestControllerTest < ActionDispatch::IntegrationTest
  test "Submitting an API request without a key will return 401 error" do
    post ingest_api_path, params: { media_review_json: { title: "Ahoy!" }.to_json }, as: :json
    assert_response 401
  end

  test "Submitting real JSON but with a bad schemas to the ingest API gives a 400" do
    post ingest_api_path, params: { media_review_json: { title: "Ahoy!" }.to_json }, as: :json
    assert_response 400

    json = nil
    assert_nothing_raised do
      json = JSON.parse(response.body)
    end

    assert_includes json.keys, "error_code"
    assert_includes json.keys, "error"
    assert_includes json.keys, "information"

    assert_equal 11, json["error_code"]
    assert_equal "Error parsing JSON, JSON does not conform to schema", json["error"]
    # TODO: add information
  end

  test "Submitting invalid JSON to the ingest API gives a 400" do
    post ingest_api_path, params: { media_review_json: { title: "Ahoy!" } }, as: :json
    assert_response 400

    json = nil
    assert_nothing_raised do
      json = JSON.parse(response.body)
    end

    assert_includes json.keys, "error_code"
    assert_includes json.keys, "error"
    assert_includes json.keys, "information"

    assert_equal 10, json["error_code"]
    assert_equal "Error parsing JSON, invalid JSON", json["error"]
    # TODO: add information
  end

  test "Can archive media review from json" do
    media_review_json = {
      "@context": "https://schema.org",
      "@type": " MediaReview",
      "datePublished": "2021-04-27",
      "url": "https://www.politifact.com/factchecks/2021/apr/27/instagram-posts/mariah-carey-didnt-fake-getting-her-covid-19-vacci/",
      "author": {
        "@type": "Organization",
        "name": "PolitiFact",
        "url": "https://politifact.com"
      },
      "mediaAuthenticityCategory": "DecontexualizedContent",
      "originalMediaContextDescription": "Singer Mariah Carey shared a video of herself receiving a COVID-19 vaccination.",
      "itemReviewed": {
        "@type": "MediaReviewItem",
        "creator": {
          "@type": "Person",
          "name": "Instagram user",
          "url": "https://www.instagram.com/wrong_saloon_bear/?hl=en"
        },
        "interpretedAsClaim": {
          "@type": "Claim",
          "description": "Mariah Carey faked getting her COVID-19 vaccine because the needle can’t be seen coming out of her arm."
        },
        "mediaItemAppearance": [
          {
            "@type": "VideoObjectSnapshot",
            "description": "An Instagram user posted a zoomed-in version of a video of Mariah Carey receiving a COVID vaccination, writing ‘It’s all a scam, don’t celebrate celebrities.’"
          },
          {
            "@type": "VideoObjectSnapshot",
            "contentUrl": "https://www.instagram.com/p/CNtao_WA0Dr/",
            "archivedAt": "https://archive.is/EXAMPLE"
          }
        ]
      }
    }.to_json

    post ingest_api_path, params: { media_review_json: media_review_json }, as: :json
    assert_response 200

    json = nil
    assert_nothing_raised do
      json = JSON.parse(response.body)
    end

    assert_includes json.keys, "response_code"
    assert_includes json.keys, "response"
    assert_includes json.keys, "media_object_id"

    assert_equal 20, json["response_code"]
    assert_equal "Successfully archived media object", json["response"]
    assert_not_empty json["media_object_id"]

    post = ArchiveItem.find(json["media_object_id"])
    assert_not_nil post
    assert_not_empty post.media_review
  end
end
