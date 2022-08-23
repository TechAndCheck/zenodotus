class Applicant < ApplicationRecord
  # A boolean value for terms acceptance stored in the database isn't good enough for auditing,
  # but a boolean attribute is useful for magic form composition and validation. Thus, we use a
  # non-database-backed attribute until model creation time, when we generate the timestamp and
  # version number for database storage.
  attr_accessor :accepted_terms

  validates :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :accepted_terms, acceptance: { message: "Terms must be accepted." }

  after_initialize :map_terms_database_values_to_accessor
  before_create :map_terms_accessor_to_database_values

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
