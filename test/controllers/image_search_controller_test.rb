# typed: ignore

require "test_helper"

class ImageSearchControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "must be logged in to view image search" do
    get image_search_url
    assert_response :redirect
  end

  test "may view image search if logged in" do
    sign_in users(:user)

    get image_search_url
    assert_response :success
  end

  # This test is currently meaningless since it redirects even when search worked.
  # test "must be logged in to perform image search" do
  #   post image_search_submit_url
  #   assert_response :redirect
  # end

  # This test is currently unimplemented since I'm unsure how to mock an
  # `ActionDispatch::Http::UploadedFile` parameter, and also (as above) it will redirect.
  # test "may perfrom image search if logged in" do
  #   sign_in users(:user)

  #   image_file = "something"

  #   post image_search_submit_url(image_search: {
  #     image: image_file
  #   })
  #   assert_response :success
  # end
end
