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
end
