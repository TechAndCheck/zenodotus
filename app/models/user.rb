class User < ApplicationRecord
  acts_as_token_authenticatable

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
