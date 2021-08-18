class User < ApplicationRecord
  has_many :api_keys, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable, :lockable

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    approved? ? super : :not_approved   # see config/locales/devise
  end
end
