require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should assign new users to default roles" do
    approved_applicant = applicants(:approved)

    user = User.create_from_applicant(approved_applicant)

    assert user.is_new_user?
    assert user.is_insights_user?
  end

  test "should recognize Insights-only users" do
    insights_user = users(:insights_user)

    assert insights_user.is_insights_user?
    assert_not insights_user.is_media_vault_user?
  end

  test "should recognize MediaVault users" do
    media_vault_user = users(:media_vault_user)

    assert media_vault_user.is_insights_user?
    assert media_vault_user.is_media_vault_user?
  end

  test "should recognize admins" do
    assert users(:admin).is_admin?
  end

  test "should recognize users are not admins" do
    assert_not users(:existing_user).is_admin?
  end

  test "can associate a user with an applicant" do
    user = users(:user1)
    applicant = applicants(:approved)

    user.update(applicant: applicant)

    assert_equal applicant, user.applicant
  end

  test "destroying user destroys applicant too" do
    user = users(:user1)
    applicant = applicants(:approved)

    user.update(applicant: applicant)

    applicant_id = applicant.id
    user_id = user.id

    user.destroy

    assert_raises ActiveRecord::RecordNotFound do
      User.find(user_id)
    end
    assert_raises ActiveRecord::RecordNotFound do
      Applicant.find(applicant_id)
    end
  end

  test "can create user from approved applicant" do
    approved_applicant = applicants(:approved)

    assert User.create_from_applicant(approved_applicant)
  end

  test "cannot create user from applicant unless approved" do
    rejected_applicant = applicants(:rejected)

    assert_raises User::ApplicantNotApprovedError do
      User.create_from_applicant(rejected_applicant)
    end
  end

  test "inherits applicant confirmation token" do
    approved_applicant = applicants(:approved)
    user = User.create_from_applicant(approved_applicant)

    assert_equal approved_applicant.confirmation_token, user.confirmation_token
  end

  test "can create a reset password token" do
    user = users(:user1)
    token = user.set_reset_password_token

    assert token
  end

  test "can look up a user with the reset token" do
    user = users(:user1)
    token = user.set_reset_password_token

    assert_equal user, User.with_reset_password_token(token)
  end

  test "can send setup email to newly-created user" do
    approved_applicant = applicants(:approved)
    new_user = User.create_from_applicant(approved_applicant)

    assert new_user.send_setup_instructions
  end

  test "cannot send setup email to previously logged-in user" do
    user = users(:existing_user)

    assert_raises User::AlreadySetupError do
      user.send_setup_instructions
    end
  end
end
