# typed: strict

class User < ApplicationRecord
  rolify
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :lockable, :confirmable

  has_many :api_keys, dependent: :delete_all
  has_many :archive_items, foreign_key: :submitter_id, dependent: :nullify

  has_many :image_searches, dependent: :destroy
  has_many :text_searches, dependent: :destroy

  has_one :applicant, dependent: :destroy

  sig { returns(T::Boolean) }
  def super_admin?
    self.super_admin
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
    raise AlreadySetupError if sign_in_count.positive?

    token = set_reset_password_token

    AccountMailer.with({
      user: self,
      token: token
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

    self.create!({
      applicant: applicant,
      email: applicant.email,
      # The user will have to change their password immediately. This is just to pass validation.
      password: Devise.friendly_token,
      # The user inherits the applicant's email confirmation.
      confirmation_token: applicant.confirmation_token,
      confirmed_at: applicant.confirmed_at,
      confirmation_sent_at: applicant.confirmation_sent_at
    })
  end
end

class User::ApplicantNotApprovedError < StandardError; end
class User::AlreadySetupError < StandardError; end
