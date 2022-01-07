require "test_helper"

class OrganizationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "index redirects without authentication" do
    get organizations_url
    assert_redirected_to new_user_session_path
  end

  test "load index if authenticated" do
    sign_in users(:user1)
    get organizations_url
    assert_response :success
  end

  # This will test vs super admin, eventually
  # test "cannot load if not a member of the organization" do
  #   sign_in users(:user2)
  #   get organizations_url
  #   assert_response :success
  # end
end
