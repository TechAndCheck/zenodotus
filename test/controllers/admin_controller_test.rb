require "test_helper"

class AdminControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should allow admins" do
    sign_in users(:admin)

    get admin_root_url

    assert_response :success
  end

  test "should not allow non-admins" do
    sign_in users(:user)

    get admin_root_url

    assert_response :redirect
    assert_equal "You don’t have permission to access that page.", flash[:error]
  end

  test "should not allow logged-out users" do
    get admin_root_url

    assert_response :redirect
    assert_equal "You need to sign in or sign up before continuing.", flash[:alert]
  end
end
