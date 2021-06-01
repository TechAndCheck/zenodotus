# typed: strict

class TwitterUser < ApplicationRecord
  include Mediable

  has_many :tweets, foreign_key: :author_id, dependent: :destroy

  # Create a +TwitterUser+ from a +Birdsong::User+
  #
  # @!scope class
  # @params birdsong_users [Array[Birdsong:User]] an array of tweets grabbed from Birdsong
  # @returns [Array[MediaItem]] and array of +MediaItem+ with type of TwitterUser that have been
  #   saved
  sig { params(birdsong_users: T::Array[Birdsong::User]).returns(T::Array[MediaItem]) }
  def self.create_from_birdsong_hash(birdsong_users)
    birdsong_users.map do |birdsong_user|
      MediaItem.create! mediable: TwitterUser.create({
        twitter_id: birdsong_user.id,
        handle: birdsong_user.username,
        display_name: birdsong_user.name,
        sign_up_date: birdsong_user.created_at,
        description: birdsong_user.description,
        url: birdsong_user.url,
        profile_image_url: birdsong_user.profile_image_url,
        location: birdsong_user.location,
      })
    end
  end

  sig { returns(String) }
  def service_id
    twitter_id
  end
end
