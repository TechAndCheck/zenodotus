# typed: strict

class User < ApplicationRecord
  rolify
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :lockable, :confirmable

  has_many :webauthn_credentials, dependent: :destroy

  has_many :api_keys, dependent: :delete_all
  has_many :archive_items, foreign_key: :submitter_id, dependent: :nullify

  has_many :image_searches, dependent: :destroy
  has_many :text_searches, dependent: :destroy

  # This is the applicant that the user was created from.
  # I.e., this is the user's own application.
  has_one :applicant, dependent: :destroy

  # These are the applicants that this user has reviewed.
  has_many :applicants, foreign_key: :reviewer_id, dependent: :nullify

  validates :name, presence: true
  validates :email, presence: true
  validates :webauthn_id, uniqueness: true, allow_nil: true

  # `Devise::Recoverable#set_reset_password_token` is a protected method, which prevents us from
  # calling it directly. Since we need to be able to do that for tests and for duck-punching other
  # `Devise::Recoverable` methods, we pull it into the public space here.
  sig { returns(String) }
  def set_reset_password_token
    super
  end

  # This is basically a clone of `Devise::Recoverable#send_reset_password_instructions`,
  # but sends an email with setup instructions instead of password reset instructions.
  # Like the original method, it also creates the user's `reset_password_token`.
  sig { returns(String) }
  def send_setup_instructions
    raise AlreadySetupError unless self.is_new_user?

    token = set_reset_password_token

    AccountMailer.with({
      user: self,
      token: token,
      site: self.site_for_setup,
    }).setup_email.deliver_later

    token
  end

  # Create a User from an approved Applicant.
  #
  # BUG: This should be `applicant: Applicant`, but that throws an error.
  #      We are temporarily using this absurdly permissive sig that works.
  #      See: https://github.com/TechAndCheck/zenodotus/issues/342
  sig { params(applicant: Object).returns(User) }
  def self.create_from_applicant(applicant)
    raise ApplicantNotApprovedError unless applicant.approved?

    user = self.create!({
      applicant: applicant,
      name: applicant.name,
      email: applicant.email,
      # The user will have to change their password immediately. This is just to pass validation.
      password: Devise.friendly_token,
      # The user inherits the applicant's email confirmation.
      confirmation_token: applicant.confirmation_token,
      confirmed_at: applicant.confirmed_at,
      confirmation_sent_at: applicant.confirmation_sent_at
    })

    user.assign_default_roles
    user.assign_applicant_roles(applicant)

    user
  end

  # All new users are implicitly Insights users.
  # All new users are also "new" until they have completed their initial setup.
  sig { void }
  def assign_default_roles
    if self.roles.blank?
      self.add_role :new_user
      self.add_role :fact_check_insights_user
    end
  end

  # Assign any roles that are implicit in the application.
  sig { params(applicant: Applicant).void }
  def assign_applicant_roles(applicant)
    self.add_role :media_vault_user if applicant.source_site == SiteDefinitions::MEDIA_VAULT[:shortname]
  end

  sig { returns(T::Boolean) }
  def can_access_fact_check_insights?
    self.is_admin? || self.is_fact_check_insights_user?
  end

  sig { returns(T::Boolean) }
  def can_access_media_vault?
    self.is_admin? || self.is_media_vault_user?
  end

private

  # ActionMailer needs to know what site we should use for the setup instructions,
  # i.e. what URLs to construct and language to use.
  sig { returns(Hash) }
  def site_for_setup
    return SiteDefinitions::MEDIA_VAULT if self.is_media_vault_user?

    SiteDefinitions::FACT_CHECK_INSIGHTS
  end
end

class User::ApplicantNotApprovedError < StandardError; end
class User::AlreadySetupError < StandardError; end
