# typed: ignore
require "test_helper"

class ArchiveControllerTest < ActionDispatch::IntegrationTest
  test "should load index" do
    get root_url
    assert_response :success
  end
end
