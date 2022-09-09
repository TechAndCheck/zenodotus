require "test_helper"

class ApplicantTest < ActiveSupport::TestCase
  def setup
    @applicant = Applicant.new
  end

  test "requires all required fields to be set" do
    assert_not @applicant.valid?

    @applicant.name = "John Doe"
    assert_not @applicant.valid?

    @applicant.email = "john@example.com"
    assert_not @applicant.valid?

    @applicant.use_case = "Journalism and fact-checking."
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
    assert applicants(:new).accepted_terms
  end

  # This test ensures that if the user's accepted terms don't match the current version, then they
  # have not "accepted the terms".
  test "must have accepted most recent terms" do
    assert_not applicants(:expired_terms).accepted_terms
  end

  # If the user has accepted terms, then they are initially valid.
  # If they attempt to unaccept, their model should not be valid.
  test "cannot un-accept terms" do
    new_applicant = applicants(:new)
    assert new_applicant.valid?

    assert_raises ActiveRecord::RecordInvalid do
      new_applicant.update!({
        accepted_terms: false
      })
    end
  end

  test "can edit applicant without triggering acceptance errors" do
    new_applicant = applicants(:new)

    assert new_applicant.update({
      name: "Janes Doe"
    })
  end

  test "can determine confirmation status correctly" do
    new_applicant = applicants(:new)

    assert_not new_applicant.confirmed?

    new_applicant.confirm

    assert new_applicant.confirmed?
  end

  test "does not reconfirm if already confirmed" do
    new_applicant = applicants(:new)

    assert new_applicant.confirm

    # Cache this timestamp so we can compare against it later
    confirmed_at = new_applicant.confirmed_at

    assert_not new_applicant.confirm

    # The timestamps should remain equal
    assert_equal confirmed_at, new_applicant.confirmed_at
  end
end
