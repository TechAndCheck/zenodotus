class Applicant < ApplicationRecord
  # This relationship is optional because not all applicants will become users.
  belongs_to :user, optional: true

  # Optional because until reviewed, the applicant does not belong to any reviewer.
  belongs_to :reviewer, class_name: "User", optional: true

  # A boolean value for terms acceptance stored in the database isn't good enough for auditing,
  # but a boolean attribute is useful for magic form composition and validation. Thus, we use a
  # non-database-backed attribute until model creation time, when we generate the timestamp and
  # version number for database storage.
  attr_accessor :accepted_terms

  enum status: {
    approved: "approved",
    rejected: "rejected"
  }

  validates :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :use_case, presence: true
  validates :accepted_terms, acceptance: { message: "Terms must be accepted." }
  validates :confirmation_token, uniqueness: true

  after_initialize :map_terms_database_values_to_accessor
  before_create :map_terms_accessor_to_database_values
  before_save :downcase_email!

  # Records the time that the we were able to successful confirm the applicant's email address.
  #
  # Returns either the boolean result of the `update` or nil if the applicant is already confirmed.
  sig { returns(T.nilable(T::Boolean)) }
  def confirm
    result = self.update(confirmed_at: Time.now) unless self.confirmed?
    # Once we have it confirmed we send an email to the admins
    self.send_admins_new_applicant_email_alert if result == true

    # Return the result of the update, not the email
    result
  end

  # Has the applicant confirmed their email address?
  sig { returns(T::Boolean) }
  def confirmed?
    self.confirmed_at.present?
  end

  # Class method for finding the applicant that matches this email/token pair.
  #
  # Even though tokens are unique (constrained by the database) and we could look it up faster with
  # just that, we want to *require* that the controller provide the matching email address, and
  # limit results to only unconfirmed applicants.
  sig { params(
    email: String,
    token: String
  ).returns(T.nilable(T.self_type)) }
  def self.find_unconfirmed_by_email_and_token(email:, token:)
    self.find_by({
      email: email,
      confirmation_token: token,
      confirmed_at: nil
    })
  end

  # Mark the review status of this applicant as approved.
  #
  # Requires that the applicant have confirmed their email address.
  # Disallows approving previously-approved applicants, but
  # allows approving unreviewed or previously-rejected applicants.
  sig { params(
    reviewer: User,
    review_note: T.nilable(String),
    review_note_internal: T.nilable(String)
  ).void }
  def approve(
    reviewer: nil,
    review_note: nil,
    review_note_internal: nil
  )
    raise UnconfirmedError unless self.confirmed?
    raise StatusChangeError if self.approved?

    self.update!({
      status: :approved,
      reviewer: reviewer,
      review_note: review_note,
      review_note_internal: review_note_internal,
      reviewed_at: Time.now
    })
  end

  # Mark the review status of this applicant as rejected.
  #
  # Requires that the applicant have confirmed their email address.
  # Disallows rejecting previously-reviewed applicants. (If they were previously approved,
  # then rejecting the application is pointless and their user account should be disabled instead.
  # If they were previously rejected, then we don't want to redundantly reject them.)
  sig { params(
    reviewer: User,
    review_note: T.nilable(String),
    review_note_internal: T.nilable(String)
  ).void }
  def reject(
    reviewer: nil,
    review_note: nil,
    review_note_internal: nil
  )
    raise UnconfirmedError unless self.confirmed?
    raise StatusChangeError if self.reviewed?

    self.update!({
      status: :rejected,
      reviewer: reviewer,
      review_note: review_note,
      review_note_internal: review_note_internal,
      reviewed_at: Time.now
    })
  end

  sig { returns(T::Boolean) }
  def reviewed?
    self.status.present?
  end

  sig { returns(T::Boolean) }
  def unreviewed?
    self.status.nil?
  end

  sig { returns(T.self_type) }
  def self.unreviewed
    Applicant.where(status: nil).where.not(confirmed_at: nil)
  end

  sig { returns(T.self_type) }
  def self.reviewed
    Applicant.where.not(status: nil).where.not(confirmed_at: nil)
  end

private

  sig { void }
  def downcase_email!
    self.email.downcase! if self.email
  end

  # The `accepted_terms` attribute should reflect the current status of the database (or itself,
  # if already set).
  sig { void }
  def map_terms_database_values_to_accessor
    has_accepted_current_terms = self.accepted_terms_at.present? &&
      self.accepted_terms_version == TermsOfService::CURRENT_VERSION

    self.accepted_terms ||= has_accepted_current_terms
  end

  # Proxy the boolean acceptance of terms to the actual data we need to store on the record.
  # See the note above on the accessor for why.
  sig { void }
  def map_terms_accessor_to_database_values
    if self.accepted_terms
      self.accepted_terms_at = Time.now
      self.accepted_terms_version = TermsOfService::CURRENT_VERSION
    end
  end

  # Send a notification email to admins that someone is requesting review.
  sig { void }
  def send_admins_new_applicant_email_alert
    @applicant = self

    NewApplicantAlertMailer.with({
      applicant: @applicant
    }).new_applicant_email.deliver_later
  end
end

class Applicant::UnconfirmedError < StandardError; end
class Applicant::StatusChangeError < StandardError; end
