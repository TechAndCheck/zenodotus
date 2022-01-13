# typed: strict
require "test_helper"

class ArchiveItemTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  test "can generate ArchiveItem JSON export" do
    post ingest_api_url_path, params: { url: "https://oneroyalace.github.io/MediaReview-Fodder/single_embedded_media_review.html", api_key: "123456789" } # archive post with mediareview
    archive_json = JSON.parse(ArchiveItem.prune_archive_items)

    assert_equal archive_json.length, 1
    assert_equal archive_json[0]["media_review"]["original_media_link"], "https://twitter.com/MariahCarey/status/1438419033267871746"
    # assert_equal archive_json[0]["media_review"]["media_authenticity_category"], "DecontextualizedContent"
    assert_equal archive_json[0]["archivable_item"]["author"]["handle"], "MariahCarey"
    assert_not_includes archive_json[0]["media_review"], "id"
  end

  test "destroying a user resets the submitter_id of ArchiveItems it created" do
    sign_in users(:user3)
    Sources::Tweet.create_from_url "https://twitter.com/unsung_son/status/1470963204855578626", users(:user3)
    assert_not_nil ArchiveItem.first.submitter
    User.destroy(users(:user3).id)
    assert_nil ArchiveItem.first.submitter
  end
end
