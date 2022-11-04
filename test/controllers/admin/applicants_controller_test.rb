require "test_helper"

class Admin::ApplicantsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    sign_in users(:admin)
  end

  test "can approve applicant" do
    applicant = applicants(:confirmed)

    assert_not applicant.approved?
    post admin_applicant_approve_path(id: applicant[:id])
    applicant.reload
    assert applicant.approved?
  end

  test "can reject applicant" do
    applicant = applicants(:confirmed)

    assert_not applicant.rejected?
    post admin_applicant_reject_path(id: applicant[:id])
    applicant.reload
    assert applicant.rejected?
  end

  test "cannot review an applicant with an unconfirmed email" do
    applicant = applicants(:new)

    assert_not applicant.confirmed?
    assert_raises Applicant::UnconfirmedError do
      post admin_applicant_approve_path(id: applicant[:id])
    end
    applicant.reload
    assert_not applicant.approved?
  end

  test "cannot reject an already-approved applicant" do
    applicant = applicants(:approved)

    assert applicant.approved?
    assert_raises Applicant::StatusChangeError do
      post admin_applicant_reject_path(id: applicant[:id])
    end
    applicant.reload
    assert_not applicant.rejected?
  end

  test "can approve an already-rejected applicant" do
    applicant = applicants(:rejected)

    assert applicant.rejected?
    post admin_applicant_approve_path(id: applicant[:id])
    applicant.reload
    assert applicant.approved?
  end

  test "can identify the reviewer" do
    admin = users(:admin)
    applicant = applicants(:confirmed)

    post admin_applicant_approve_path(id: applicant[:id])
    applicant.reload
    assert_equal admin, applicant.reviewer
  end
end
