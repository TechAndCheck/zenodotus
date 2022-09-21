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

  test "should lowercase email address during creation" do
    applicant = Applicant.create!({
      name: "Jane Doe",
      email: "JANE@EXAMPLE.COM",
      use_case: "Use case",
      accepted_terms_at: Time.now,
      accepted_terms_version: TermsOfService::CURRENT_VERSION,
      confirmation_token: Devise.friendly_token,
    })

    assert_equal applicant.email.downcase, applicant.email
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

  test "can only review a confirmed applicant" do
    new_applicant = applicants(:new)

    assert_raises Applicant::UnconfirmedError do
      new_applicant.approve
    end

    new_applicant.confirm
    new_applicant.approve

    assert new_applicant.approved?
  end

  test "can approve an applicant only once" do
    confirmed_applicant = applicants(:confirmed)

    confirmed_applicant.approve

    assert confirmed_applicant.approved?
    assert_raises Applicant::StatusChangeError do
      confirmed_applicant.approve
    end
  end

  test "can reject an applicant only once" do
    confirmed_applicant = applicants(:confirmed)

    confirmed_applicant.reject

    assert confirmed_applicant.rejected?
    assert_raises Applicant::StatusChangeError do
      confirmed_applicant.reject
    end
  end

  test "can determine review status of applicant" do
    confirmed_applicant = applicants(:confirmed)

    assert confirmed_applicant.unreviewed?
    assert_not confirmed_applicant.reviewed?

    confirmed_applicant.approve

    assert_not confirmed_applicant.unreviewed?
    assert confirmed_applicant.reviewed?
  end

  test "can add notes during approval" do
    confirmed_applicant = applicants(:confirmed)

    review_note = "Friend of mine"

    confirmed_applicant.approve(
      review_note: review_note,
      review_note_internal: review_note
    )

    assert_equal review_note, confirmed_applicant.review_note
    assert_equal review_note, confirmed_applicant.review_note_internal
  end

  test "can add notes during rejection" do
    confirmed_applicant = applicants(:confirmed)

    review_note = "Friend of mine"

    confirmed_applicant.reject(
      review_note: review_note,
      review_note_internal: review_note
    )

    assert_equal review_note, confirmed_applicant.review_note
    assert_equal review_note, confirmed_applicant.review_note_internal
  end
end
