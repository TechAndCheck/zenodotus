# typed: strict
require "test_helper"

class ArchiveItemTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  test "can generate ArchiveItem JSON export" do
    post ingest_api_url_path, params: { url: "https://oneroyalace.github.io/MediaReview-Fodder/single_embedded_media_review.html", api_key: "123456789" } # archive post with mediareview
    archive_json = JSON.parse(ArchiveItem.prune_archive_items)

    assert_equal archive_json.length, 1
    assert_equal 20, JSON.parse(response.body)["response_code"]
  end

  test "destroying a user resets the submitter_id of ArchiveItems it created" do
    sign_in users(:user3)
    Sources::Tweet.create_from_url "https://twitter.com/unsung_son/status/1470963204855578626", users(:user3)
    assert_not_nil ArchiveItem.first.submitter
    User.destroy(users(:user3).id)
    assert_nil ArchiveItem.first.submitter
  end

  test "scraping a post creates a screenshot" do
    forki_post = FacebookMediaSource.extract("https://www.facebook.com/Meta/photos/a.108824087345859/336596487901950", true)["scrape_result"]
    archive_item = Sources::FacebookPost.create_from_forki_hash(forki_post).first
    assert_not_nil archive_item.screenshot
  end
end
