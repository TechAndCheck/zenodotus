# typed: strict
require "test_helper"

class ArchiveItemTest < ActionDispatch::IntegrationTest
  test "can generate ArchiveItem JSON export" do
    post ingest_api_url_path, params: { url: "https://oneroyalace.github.io/MediaReview-Fodder/single_embedded_media_review.html", api_key: "123456789" } # archive post with mediareview
    archive_json = JSON.parse(ArchiveItem.prune_archive_items)

    assert_equal archive_json.length, 1
    assert_equal archive_json[0]["media_review"]["original_media_link"], "https://twitter.com/MariahCarey/status/1438419033267871746"
    # assert_equal archive_json[0]["media_review"]["media_authenticity_category"], "DecontextualizedContent"
    assert_equal archive_json[0]["archivable_item"]["author"]["handle"], "MariahCarey"
    assert_not_includes archive_json[0]["media_review"], "id"
  end
end
