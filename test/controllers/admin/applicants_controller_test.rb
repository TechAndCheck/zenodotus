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
    assert_predicate applicant, :approved?
  end

  test "can reject applicant" do
    applicant = applicants(:confirmed)

    assert_not applicant.rejected?
    post admin_applicant_reject_path(id: applicant[:id])
    applicant.reload
    assert_predicate applicant, :rejected?
  end

  test "can delete applicant" do
    applicant = applicants(:confirmed)

    delete admin_applicant_delete_path(id: applicant[:id])

    assert_not Applicant.exists?(applicant[:id])
  end

  test "cannot review an applicant with an unconfirmed email" do
    applicant = applicants(:new)

    assert_not applicant.confirmed?

    post admin_applicant_approve_path(id: applicant[:id])
    assert_response :precondition_failed

    applicant.reload
    assert_not applicant.approved?
  end

  test "cannot reject an already-approved applicant" do
    applicant = applicants(:approved)

    assert_predicate applicant, :approved?
    post admin_applicant_reject_path(id: applicant[:id])
    assert_response :precondition_failed

    applicant.reload
    assert_not applicant.rejected?
  end

  test "can approve an already-rejected applicant" do
    applicant = applicants(:rejected)

    assert_predicate applicant, :rejected?
    post admin_applicant_approve_path(id: applicant[:id])
    applicant.reload
    assert_predicate applicant, :approved?
  end

  test "can identify the reviewer" do
    admin = users(:admin)
    applicant = applicants(:confirmed)

    post admin_applicant_approve_path(id: applicant[:id])
    applicant.reload
    assert_equal admin, applicant.reviewer
  end

  test "can update roles for a user" do
    applicant = applicants(:confirmed)

    post admin_applicant_approve_path(id: applicant[:id])

    user = User.find_by(email: applicant[:email])
    assert user.has_role?(:fact_check_insights_user)
    assert_not user.has_role?(:media_vault_user)

    post admin_applicant_update_path(id: applicant[:id], params: { fact_check_insights_enabled: "0", media_vault_enabled: "1" })

    user.reload
    assert_not user.has_role?(:fact_check_insights_user)
    assert user.has_role?(:media_vault_user)
  end
end
