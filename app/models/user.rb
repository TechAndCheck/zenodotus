class User < ApplicationRecord
  has_many :api_keys, dependent: :destroy
  has_many :archive_items, foreign_key: :submitter_id, dependent: :nullify
  has_many :image_searches, foreign_key: :submitter_id, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :lockable # , :confirmable
  # TODO: re-enable :confirmable after mailer is set up

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    approved? ? super : :not_approved   # see config/locales/devise
  end
end
