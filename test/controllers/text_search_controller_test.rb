# typed: ignore

require "test_helper"

class ArchiveControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "can run text search" do
    # First we need to create a few posts.
    Sources::Tweet.create_from_url("https://twitter.com/POTUS/status/1430341234472669188")
    Sources::Tweet.create_from_url("https://twitter.com/ggreenwald/status/1430523746457112578")
    Sources::Tweet.create_from_url("https://twitter.com/bidenfoundation/status/1121446608040755200")
    Sources::Tweet.create_from_url("https://twitter.com/POTUS/status/1428115295756066824")
    sign_in users(:user1)

    # And then search
    get text_search_submit_url, params: { query: "Biden" }

    assert_response 200
    assert_equal TextSearch.all.length, 1
  end
end
