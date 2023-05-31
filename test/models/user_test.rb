require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should assign new users to default roles" do
    approved_applicant = applicants(:approved)

    user = User.create_from_applicant(approved_applicant)

    assert user.is_new_user?
    assert user.is_fact_check_insights_user?
  end

  test "should assign Vault applicants the Vault role" do
    approved_vault_applicant = applicants(:approved_vault)

    user = User.create_from_applicant(approved_vault_applicant)

    assert user.is_media_vault_user?
  end

  test "should recognize Insights-only users" do
    fact_check_insights_user = users(:fact_check_insights_user)

    assert fact_check_insights_user.is_fact_check_insights_user?
    assert_not fact_check_insights_user.is_media_vault_user?
  end

  test "should recognize MediaVault users" do
    media_vault_user = users(:media_vault_user)

    assert media_vault_user.is_fact_check_insights_user?
    assert media_vault_user.is_media_vault_user?
  end

  test "should recognize admins" do
    assert users(:admin).is_admin?
  end

  test "should recognize users are not admins" do
    assert_not users(:user).is_admin?
  end

  test "can associate a user with an applicant" do
    user = users(:user)
    applicant = applicants(:approved)

    user.update(applicant: applicant)

    assert_equal applicant, user.applicant
  end

  test "destroying user destroys applicant too" do
    user = users(:user)
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
    user = users(:user)
    token = user.set_reset_password_token

    assert token
  end

  test "can look up a user with the reset token" do
    user = users(:user)
    token = user.set_reset_password_token

    assert_equal user, User.with_reset_password_token(token)
  end

  test "can send setup email to newly-created user" do
    approved_applicant = applicants(:approved)
    new_user = User.create_from_applicant(approved_applicant)

    assert new_user.send_setup_instructions
  end

  test "cannot send setup email to previously logged-in user" do
    user = users(:fact_check_insights_user)

    assert_raises User::AlreadySetupError do
      user.send_setup_instructions
    end
  end

  test "can generate recovery codes" do
    user = users(:fact_check_insights_user)

    assert user.hashed_recovery_codes.empty?
    recovery_codes = user.generate_recovery_codes
    assert_not user.hashed_recovery_codes.empty?

    assert_equal 10, recovery_codes.count
    assert_equal 10, user.hashed_recovery_codes.count
  end

  test "can validate a recovery code" do
    user = users(:fact_check_insights_user)
    recovery_codes = user.generate_recovery_codes

    assert user.validate_recovery_code(recovery_codes.first)
    assert_equal 9, user.hashed_recovery_codes.count
  end

  test "fails on a invalid recovery code" do
    user = users(:fact_check_insights_user)
    user.generate_recovery_codes

    assert_not user.validate_recovery_code("sldfkjsoifnwonwonwf")
    assert_equal 10, user.hashed_recovery_codes.count
  end

  test "asserting an invalid code runs in the same time no matter how many have been removed" do
    user = users(:fact_check_insights_user)
    recovery_codes = user.generate_recovery_codes

    start_time = Time.now
    user.validate_recovery_code("llkfjoifjwoiknwoifnwffosnfosifnsoifns")
    first_validate_time = Time.now - start_time

    user.validate_recovery_code(recovery_codes.first)
    user.validate_recovery_code(recovery_codes.first)
    user.validate_recovery_code(recovery_codes.first)
    user.validate_recovery_code(recovery_codes.first)
    user.validate_recovery_code(recovery_codes.first)
    user.validate_recovery_code(recovery_codes.first)

    start_time = Time.now
    user.validate_recovery_code("llkfjoifjwoiknwoifnwffosnfosifnsoifns")
    second_validate_time = Time.now - start_time

    # Should run similarly
    assert second_validate_time - first_validate_time < 0.4
  end

  test "can generate a provisioning code for a mobile device for a user" do
    user = users(:user_no_totp)
    uri = user.generate_totp_provisioning_uri

    assert_not_nil user.totp_secret
    assert_not_nil uri
  end

  test "can validate a totp login code for a user" do
    user = users(:user_no_totp)
    user.generate_totp_provisioning_uri

    # assert user.validate_totp_login_code("123456") # TODO: Make this a real code somehow
  end

  test "can de-validate a wrong totp login code for a user" do
    user = users(:user_no_totp)
    user.generate_totp_provisioning_uri

    assert_equal false, user.validate_totp_login_code("123456")
  end
end
