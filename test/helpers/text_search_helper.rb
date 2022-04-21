require "test_helper"

class TextSearchHelperTest < ActionView::TestCase
  include Devise::Test::IntegrationHelpers

  test "text search view finder helper" do
    youtube_post = Sources::YoutubePost.create_from_url! "https://www.youtube.com/shorts/uR4BzP61Jvk"
    assert_equal search_view_for_model_instance(youtube_post), "text_search_youtube_post"
  end
end
