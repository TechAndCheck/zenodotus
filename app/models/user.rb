class User < ApplicationRecord
  has_many :api_keys, dependent: :delete_all
  has_many :archive_items, foreign_key: :submitter_id, dependent: :nullify

  has_many :image_searches, dependent: :destroy
  has_many :text_searches, dependent: :destroy

  belongs_to :organization, required: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :lockable # , :confirmable
  # TODO: re-enable :confirmable after mailer is set up

  before_destroy :check_if_admin_before_destroying

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    approved? ? super : :not_approved   # see config/locales/devise
  end

  def admin?
    # The Bullet gem throws an eager loading error if we don't do it like this. There shouldn't be a
    # slow down in any way, since this is the same thing as `self.organization`
    Organization.find(self.organization_id).admin == self
  end

private

  def check_if_admin_before_destroying
    raise User::DontDestroyIfAdminError.new("Replace #{self.email} as admin of #{self.organization.name} before deleting the user.") if self.admin?
  end
end

class User::DontDestroyIfAdminError < StandardError; end
