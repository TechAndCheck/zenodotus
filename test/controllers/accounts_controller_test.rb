require "test_helper"

class AccountsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "can get the setup page with a valid token" do
    user = users(:user1)

    token = user.set_reset_password_token

    get new_account_path(token: token)
    assert_response :success
  end

  test "cannot get setup page without a valid token" do
    get new_account_path
    assert_response :bad_request

    get new_account_path(token: "abc123")
    assert_response :bad_request
  end

  test "cannot get setup page while logged in" do
    user = users(:user1)

    # Use a valid token to make this a legitimate test.
    # The redirection will run before the token is even checked, but we want to make sure it's an
    # otherwise valid request.
    token = user.set_reset_password_token

    sign_in user
    get new_account_path(token: token)

    assert_response :redirect
    assert_equal "You cannot access that resource while logged in. Please log out and try again.", flash[:error]
  end

  test "can setup an account as a new user" do
    user = users(:user1)

    post create_account_path({
      reset_password_token: user.set_reset_password_token,
      password: "password1",
      password_confirmation: "password1"
    })

    assert_redirected_to @controller.after_sign_in_path_for(user)
  end

  test "cannot setup an account without a valid token" do
    post create_account_path({
      reset_password_token: "abc123",
      password: "password1",
      password_confirmation: "password1"
    })
    assert_response :bad_request
  end

  test "cannot setup an account with a previously-used token" do
    user = users(:user1)

    create_params = {
      reset_password_token: user.set_reset_password_token,
      password: "password1",
      password_confirmation: "password1"
    }

    post create_account_path(create_params)
    assert_redirected_to @controller.after_sign_in_path_for(user)

    # Necessary because `post create_account_path()` signs in the user.
    sign_out user

    post create_account_path(create_params)
    assert_response :bad_request
  end

  test "cannot setup an account with blank passwords" do
    user = users(:user1)

    post create_account_path({
      reset_password_token: user.set_reset_password_token,
      password: "",
      password_confirmation: ""
    })
    assert_response :bad_request
  end

  test "cannot setup an account with short passwords" do
    user = users(:user1)
    short_password = "password"[0, Devise.password_length.begin - 1]

    post create_account_path({
      reset_password_token: user.set_reset_password_token,
      password: short_password,
      password_confirmation: short_password
    })
    assert_response :bad_request
  end

  test "cannot setup an account with mismatching passwords" do
    user = users(:user1)

    post create_account_path({
      reset_password_token: user.set_reset_password_token,
      password: "password1",
      password_confirmation: "password2"
    })
    assert_response :bad_request
  end
end
