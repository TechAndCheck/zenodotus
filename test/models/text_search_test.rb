require "test_helper"

class TextSearchTest < ActiveSupport::TestCase
  def setup
    @text_search = TextSearch.create(query: "Biden")
  end

  test "can create text search" do
    assert_not_nil @text_search
    assert_not_nil @text_search.query
  end

  test "can run text search" do
    # First we need to create a few posts.
    Sources::Tweet.create_from_url("https://twitter.com/POTUS/status/1430341234472669188")
    Sources::Tweet.create_from_url("https://twitter.com/ggreenwald/status/1430523746457112578")
    Sources::Tweet.create_from_url("https://twitter.com/bidenfoundation/status/1121446608040755200")
    Sources::Tweet.create_from_url("https://twitter.com/POTUS/status/1428115295756066824")
    results = @text_search.run

    # Then ensure that search is finding users and posts
    assert_not_nil results
    assert_equal results[:user_search_hits].length, 2  # POTUS, Biden Foundation
    assert_equal results[:post_search_hits].length, 2  # Greenwald tweet, Biden Foundation tweet
    assert_equal TextSearch.all.length, 1
  end
end
