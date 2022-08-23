require "test_helper"

class ApplicantTest < ActiveSupport::TestCase
  def setup
    @applicant = Applicant.new
  end

  test "requires name, email, and acceptance" do
    assert_not @applicant.valid?

    @applicant.name = "John Doe"
    assert_not @applicant.valid?

    @applicant.email = "john@example.com"
    assert_not @applicant.valid?

    @applicant.accepted_terms = true
    assert @applicant.valid?

    @applicant.accepted_terms = false
    assert_not @applicant.valid?
  end

  test "cannot create an applicant without accepting terms" do
    assert_raises ActiveRecord::RecordInvalid do
      Applicant.create!({
        name: "John Doe",
        email: "john@example.com"
      })
    end
  end

  # This test ensures that if the model has its terms-acceptance database attributes populated
  # properly, that the model itself sets the `accepted_terms` attribute accordingly during init.
  test "can convert terms-acceptance attributes from database" do
    assert applicants(:jane).accepted_terms
  end

  # This test ensures that if the user's accepted terms don't match the current version, then they
  # have not "accepted the terms".
  test "must have accepted most recent terms" do
    assert_not applicants(:expired_terms).accepted_terms
  end

  # If the user has accepted terms, then they are initially valid.
  # If they attempt to unaccept, their model should not be valid.
  test "cannot un-accept terms" do
    jane = applicants(:jane)
    assert jane.valid?

    assert_raises ActiveRecord::RecordInvalid do
      jane.update!({
        accepted_terms: false
      })
    end
  end

  test "can edit applicant without triggering acceptance errors" do
    jane = applicants(:jane)

    assert_nothing_raised do
      jane.update!({
        name: "Janes Doe"
      })
    end
  end
end
