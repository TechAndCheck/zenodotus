require "test_helper"

class ApplicantsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "can access the apply page while logged out" do
    get new_applicant_path
    assert_response :success
  end

  test "cannot access the apply page while logged in" do
    user = users(:user)

    sign_in user

    get new_applicant_path
    assert_response :redirect
  end

  test "creates an applicant" do
    post applicants_path(applicant: {
      name: "Jane Doe",
      email: "applicant@example.com",
      use_case: "Journalism?",
      accepted_terms: "1",
    })

    assert Applicant.find_by(email: "applicant@example.com")
    assert_redirected_to applicant_confirmation_sent_path
  end

  test "redirects to confirmation sent page after creation" do
    post applicants_path(applicant: {
      name: "Jane Doe",
      email: "applicant@example.com",
      use_case: "Journalism?",
      accepted_terms: "1",
    })

    assert_redirected_to applicant_confirmation_sent_path
  end

  test "returns a bad request if validations fails during creation" do
    post applicants_path(applicant: {
      name: "Jane Doe",
    })

    assert_response :bad_request
  end

  test "should not allow applying with existing user email" do
    user = users(:user)

    post applicants_path(applicant: {
      name: "Jane Doe",
      email: user.email,
      use_case: "Journalism?",
      accepted_terms: "1",
    })

    assert_response :bad_request
  end

  test "should not allow applying with existing user email in different case" do
    user = users(:user)

    post applicants_path(applicant: {
      name: "Jane Doe",
      email: user.email.upcase,
      use_case: "Journalism?",
      accepted_terms: "1",
    })

    assert_response :bad_request
  end
end
