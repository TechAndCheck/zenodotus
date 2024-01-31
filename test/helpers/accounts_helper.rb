require "test_helper"

class AccountsHelperTest < ActionView::TestCase
  include Devise::Test::IntegrationHelpers

  test "search_history_helper" do
    sign_in users(:user)
    TextSearch.create(query: "search term", user: User.first)
    TextSearch.create(query: "another search term", user: User.first)
    TextSearch.create(query: "yet another search term", user: User.first)

    search_records = TextSearch.all
    dated_search_records = split_searches_by_date(search_records)
    assert_not_nil dated_search_records
    assert_equal 3, dated_search_records[dated_search_records.keys.first].length
  end
end
