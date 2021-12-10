require "test_helper"

class TextSearchTest < ActiveSupport::TestCase
  include Devise::Test::IntegrationHelpers
  def setup
    @text_search = TextSearch.create(query: "Biden")
  end

  test "can create text search" do
    assert_not_nil @text_search
    assert_not_nil @text_search.query
  end
end
