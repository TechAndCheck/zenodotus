# typed: strict

class User < ApplicationRecord
  has_many :api_keys, dependent: :delete_all
  has_many :archive_items, foreign_key: :submitter_id, dependent: :nullify

  has_many :image_searches, dependent: :destroy
  has_many :text_searches, dependent: :destroy

  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :lockable, :confirmable

  sig { returns(T::Boolean) }
  def super_admin?
    self.super_admin
  end
end
