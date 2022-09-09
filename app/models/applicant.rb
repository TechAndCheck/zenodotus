class Applicant < ApplicationRecord
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

  # Records the time that the we were able to successful confirm the applicant's email address.
  #
  # Returns either the boolean result of the `update` or nil if the applicant is already confirmed.
  sig { returns(T.nilable(T::Boolean)) }
  def confirm
    self.update(confirmed_at: Time.now) unless self.confirmed?
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

private

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
end
