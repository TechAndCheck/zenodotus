# typed: strict

class Sources::TwitterUser < ApplicationRecord
  include ArchivableEntity
  include ImageUploader::Attachment(:profile_image) # adds an `image` virtual attribute
  include PgSearch::Model


  multisearchable using: {
                    tsearch: {
                      dictionary: "english",
                      tsvector_column: "content_tsvector"
                    }
                  }

  # The tweets that a TwitterUser have authored
  has_many :tweets, foreign_key: :author_id, dependent: :destroy

  # Create a +TwitterUser+ from a +Birdsong::User+
  #
  # @!scope class
  # @params birdsong_users [Array[Birdsong:User]] an array of tweets grabbed from Birdsong
  # @returns [Array[ArchiveEntity]] an array of +ArchiveEntity+ with type of TwitterUser that have been
  #   saved
  sig { params(birdsong_users: T::Array[Birdsong::User]).returns(T::Array[ArchiveEntity]) }
  def self.create_from_birdsong_hash(birdsong_users)
    birdsong_users.map do |birdsong_user|
      # First check if the user already exists, if so, return that
      twitter_user = Sources::TwitterUser.find_by(twitter_id: birdsong_user.id)
      twitter_user_hash  = self.twitter_user_hash_from_birdsong_user(birdsong_user)

      # If there's no user, then create it
      if twitter_user.nil?
        twitter_user = ArchiveEntity.create! archivable_entity: Sources::TwitterUser.create(twitter_user_hash)
      else
        # Update twitter user with the new data
        #
        # Question: do we want to version this at some point so we can tell what the user had when
        # it was accessed at any given time?
        twitter_user.update!(twitter_user_hash)

        # We return the ArchiveEntity, because it's expected
        twitter_user = twitter_user.archive_entity
      end

      twitter_user
    end
  end

  # The unique service id for this item
  #
  # @returns String the id assigned by Twitter to this user
  sig { returns(String) }
  def service_id
    twitter_id
  end

private

  # Create a hash from a Birdsong::User suitable for a new TwitterUser or updating one
  #
  # @!scope class
  # @!visibility private
  # @params birdsong_users Birdsong:User an tweet grabbed from Birdsong
  # @returns Hash a data structure suitable to pass to `create` or `update`
  sig { params(birdsong_user: Birdsong::User).returns(Hash) }
  def self.twitter_user_hash_from_birdsong_user(birdsong_user)
    {
      twitter_id: birdsong_user.id,
      handle: birdsong_user.username,
      display_name: birdsong_user.name,
      sign_up_date: birdsong_user.created_at,
      description: birdsong_user.description,
      url: birdsong_user.url,
      profile_image_url: birdsong_user.profile_image_url,
      location: birdsong_user.location,
      profile_image: File.open(birdsong_user.profile_image_file_name, "rb"),
      followers_count: birdsong_user.followers_count,
      following_count: birdsong_user.following_count
    }
  end
end
