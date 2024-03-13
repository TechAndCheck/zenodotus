# typed: strict

require "bcrypt"

class User < ApplicationRecord
  rolify
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :lockable, :confirmable

  has_many :webauthn_credentials, dependent: :destroy

  has_many :api_keys, dependent: :delete_all
  # has_many :archive_items, foreign_key: :submitter_id, dependent: :nullify

  has_many :image_searches, dependent: :destroy
  has_many :text_searches, dependent: :destroy

  # This is the applicant that the user was created from.
  # I.e., this is the user's own application.
  has_one :applicant, dependent: :destroy

  # These are the applicants that this user has reviewed.
  has_many :applicants, foreign_key: :reviewer_id, dependent: :nullify

  has_many :corpus_downloads, dependent: :nullify

  has_many :archive_items_users, dependent: :destroy, class_name: "ArchiveItemUser"
  has_many :archive_items, through: :archive_items_users

  validates :name, presence: true
  validates :email, presence: true
  validates :webauthn_id, uniqueness: true, allow_nil: true

  # Get private archive items that the user has access to. This is what should always be used,
  # For some reason i can't get unscoped auto stuff to work on the association
  sig { returns(ArchiveItem::ActiveRecord_Relation) }
  def private_archive_items
    self.archive_items.unscoped
  end

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
    }).setup_email.deliver_now

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

  sig { returns(T::Array[String]) }
  def generate_recovery_codes
    raise "Recovery codes already generated for user" unless self.hashed_recovery_codes.empty?
    # For ease the format is a 24 hex. When we show it to the user we'll do it like XXXXX-XXXXXX-XXXXXX-XXXXXX
    # This above still needs to happen
    # We'll have to remember to remove the dashes before checking, but not bad.
    #
    # There are ten codes when generated
    keys = 10.times.map { SecureRandom.hex(24) }

    # Get the BCrypt (it's slow and long, that's good here, and included in Rails already) version of each
    # which is what we actually save
    hashed_keys = keys.map { |key| BCrypt::Password.create(key) }

    # Save the hashed keys, and return the plaintext ones
    self.update!(hashed_recovery_codes: hashed_keys)
    keys
  end

  sig { params(recovery_code: String, invalidate_after_confirm: T::Boolean).returns(T::Boolean) }
  def validate_recovery_code(recovery_code, invalidate_after_confirm: true)
    timing_attack_key = BCrypt::Password.create(SecureRandom.hex(24))

    self.hashed_recovery_codes.each do |hashed_recovery_code|
      # If it works, we remove it if we're invalidating and return true
      if BCrypt::Password.new(hashed_recovery_code) == recovery_code
        if invalidate_after_confirm
          self.hashed_recovery_codes.delete(hashed_recovery_code)
          self.update!(
            hashed_recovery_codes: self.hashed_recovery_codes
          )
        end

        return true
      end
    end

    # To prevent timing attacks we want to make sure we're always checking ten strings
    (10 - self.hashed_recovery_codes.count).times do
      # Just do a compare to kill time but ignore the results
      recovery_code == timing_attack_key
    end

    false # Return false since if we're here there's no comparison
  end

  # Check if Webauthn or TOTP is enabled
  sig { returns(T::Boolean) }
  def mfa_enabled?
    self.webauthn_credentials.count.positive? || self.totp_confirmed
  end

  # Generate a TOTP provisioning uri, overwriting the old one if it's not empty
  # This is generally implemented to support Firefox, though anyone can use it
  # The returned URI should be rendered as a QRCode and scanned by the user's authenticator app
  sig { returns(String) }
  def generate_totp_provisioning_uri
    # Prevent an attacker from overwriting a confirmed TOTP code
    raise "TOTP already setup" if self.totp_confirmed == true

    self.update!({ totp_secret: ROTP::Base32.random_base32 })

    totp = ROTP::TOTP.new(self.totp_secret, issuer: "Fact Check Insights\\Media Vault")
    totp.provisioning_uri(self.email)
  end

  def clear_totp_secret
    self.update!({ totp_secret: nil, totp_confirmed: false })
  end

  # Validate a TOTP code, returning true or false
  sig { params(totp_code: String).returns(T::Boolean) }
  def validate_totp_login_code(totp_code)
    return false if self.totp_secret.nil? # If we're not set up just always reject it all

    totp = ROTP::TOTP.new(self.totp_secret)
    verify_result = totp.verify(totp_code, drift_behind: 15, at: Time.now)

    !verify_result.nil?
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
