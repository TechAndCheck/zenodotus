require "test_helper"

class UserTest < ActiveSupport::TestCase
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
end
