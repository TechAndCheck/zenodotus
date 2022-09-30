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

  test "should lowercase email address during creation" do
    email_upcase = "APPLICANT@EXAMPLE.COM"
    email_downcase = email_upcase.downcase

    post applicants_path(applicant: {
      name: "Jane Doe",
      email: email_upcase,
      use_case: "Journalism?",
      accepted_terms: "1",
    })

    assert_nil Applicant.find_by(email: email_upcase)

    applicant = Applicant.find_by(email: email_downcase)

    assert_equal email_downcase, applicant.email
  end

  test "should default the site source to Insights" do
    post applicants_path(applicant: {
      name: "Jane Doe",
      email: "applicant-insights@example.com",
      use_case: "Journalism?",
      accepted_terms: "1",
    })
    applicant = Applicant.find_by(email: "applicant-insights@example.com")

    assert_equal "fact_check_insights", applicant[:source_site]
  end

  test "can record that an applicant came from the Vault application page" do
    host! "vault.factcheckinsights.local"

    post applicants_path(applicant: {
      name: "Jane Doe",
      email: "applicant-vault@example.com",
      use_case: "Journalism?",
      accepted_terms: "1",
    })
    applicant = Applicant.find_by(email: "applicant-vault@example.com")

    assert_equal "media_vault", applicant[:source_site]
  end
end
