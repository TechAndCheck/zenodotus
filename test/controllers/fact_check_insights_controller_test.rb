require "test_helper"

class FactCheckInsightsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include Minitest::Hooks

  setup do
    host! Figaro.env.FACT_CHECK_INSIGHTS_HOST
  end

  # Create an ArchiveItem, a MediaReview object, and a ClaimReview object
  def before_all
    return if File.exist?("tmp/") && File.directory?("tmp/")
    FileUtils.mkdir_p("tmp/")

    media_review = MediaReview.create!(
      media_url: "https://www.foobar.com/1",
      original_media_link: "https://www.foobar.com/1_original_media_link",
      date_published: "2021-02-03",
      url: "https://www.realfact.com/factchecks/2021/feb/03/starwars",
      author: {
        "@type": "Organization",
        "name": "realfact",
        "url": "https://realfact.com",
        "image": "https://i.kym-cdn.com/photos/images/newsfeed/001/207/210/b22.jpg",
        "sameAs": "https://twitter.com/realfact"
      },
      media_authenticity_category: "TransformedContent",
      original_media_context_description: "Star Wars Ipsum",
      item_reviewed: {
        "@type": "MediaReviewItem",
        "creator": {
          "@type": "Person",
          "name": "Old Ben-Kenobi",
          "url": "https://www.foobar.com/x/1"
        },
        "interpretedAsClaim": {
          "@type": "Claim",
          "description": "Two droids on the imperial watchlist entered a hovercraft"
        },
        "embeddedTextCaption": "Your droids. They’ll have to wait outside. We don’t want them here. Listen, why don’t you wait out by the speeder. We don’t want any trouble.",
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
      },
    )

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
        "datePublished": "2021-01-30",
        "name": "Star Wars claim",
        "author": {
          "@type": "Person",
          "jobTitle": "On the internet",
          "name": "Viral image"
        },
        "appearance": [
          {
            "@type": "CreativeWork",
            "url": "https://foobar.com/13531"
          }
        ]
      },
      review_rating: {
        "@type": "Rating",
        "ratingValue": "4",
        "bestRating": "5",
        "worstRating": "0",
        "ratingDescription": "Don't worry about it",
        "image": "https://static.politifact.com/politifact/rulings/meter-false.jpg",
        "alternateName": "False"
      },
      url: "https://www.realfact.com/factchecks/2021/feb/03/starwars",
      media_review: media_review
    )
  end

  test "can generate Fact Check Insights JSON export" do
    json_export = JSON.parse(FactCheckInsightsController.generate_json)
    assert json_export["meta"]["mediaReviewCount"].positive?
    assert json_export["meta"]["claimReviewCount"].positive?
  end

  # Generate a csv zip file, write it to disk, read it, then validate it
  test "can generate Fact Check Insights csv zip export" do
    zipped_csvs = FactCheckInsightsController.generate_csv_zip
    File.binwrite("tmp/csvs.zip", zipped_csvs)

    claim_reviews = nil
    media_reviews = nil
    Zip::File.open("tmp/csvs.zip") do |zip_file|
      claim_reviews = CSV.parse(zip_file.glob("claim_reviews.csv").first.get_input_stream.read)
      media_reviews = CSV.parse(zip_file.glob("media_reviews.csv").first.get_input_stream.read)
    end
  end

  test "can download data as an admin" do
    skip "Waiting to turn on Insights first"
    sign_in users(:admin)

    get fact_check_insights_download_path(format: :json)
    assert_response :success

    get fact_check_insights_download_path(format: :zip)
    assert_response :success
  end

  test "can download data as a permitted user" do
    skip "Waiting to turn on Insights first"
    sign_in users(:fact_check_insights_user)

    get fact_check_insights_download_path(format: :json)
    assert_response :success

    get fact_check_insights_download_path(format: :zip)
    assert_response :success
  end

  test "cannot download data when not logged in" do
    get fact_check_insights_download_path(format: :json)
    assert_response :unauthorized

    get fact_check_insights_download_path(format: :zip)
    assert_response :unauthorized
  end

  test "cannot download data from the Vault hostname" do
    host! Figaro.env.MEDIA_VAULT_HOST

    assert_raises ActionController::RoutingError do
      get fact_check_insights_download_path(format: :json)
    end
  end
end
