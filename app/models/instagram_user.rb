# typed: false

class InstagramUser < ApplicationRecord
  include ArchivableEntity
  include ImageUploader::Attachment(:profile_image) # adds an `image` virtual attribute

  # The tweets that an InstagramUser have authored
  has_many :instagram_posts, foreign_key: :author_id, dependent: :destroy

  # Create an +InstagramUser+ from a +Zorki::User+
  #
  # @!scope class
  # @params birdsong_users [Array[Zorki:User]] an array of tweets grabbed from Zorki
  # @returns [Array[ArchiveEntity]] an array of +ArchiveEntity+ with type of InstagramUser that have been
  #   saved
  sig { params(zorki_users: T::Array[Zorki::User]).returns(T::Array[ArchiveEntity]) }
  def self.create_from_zorki_hash(zorki_users)
    zorki_users.map do |zorki_user|
      # First check if the user already exists, if so, return that
      instagram_user = InstagramUser.find_by(handle: zorki_user.username)
      zorki_user_hash = self.instagram_user_hash_from_zorki_user(zorki_user)

      # If there's no user, then create it
      if instagram_user.nil?
        instagram_user = ArchiveEntity.create! archivable_entity: InstagramUser.create!(zorki_user_hash)
      else
        # Update Instagram user with the new data
        #
        # Question: do we want to version this at some point so we can tell what the user had when
        # it was accessed at any given time?
        instagram_user.update!(zorki_user_hash)

        # We return the ArchiveEntity, because it's expected
        instagram_user = instagram_user.archive_entity
      end

      instagram_user
    end
  end

  # The unique service id for this item
  #
  # @returns String the id assigned by Instagram to this user
  sig { returns(String) }
  def service_id
    handle
  end

private

  # Create a hash from a Zorki::User suitable for a new InstagramUser or updating one
  #
  # @!scope class
  # @!visibility private
  # @params birdsong_users Zorki:User an tweet grabbed from Zorki
  # @returns Hash a data structure suitable to pass to `create` or `update`
  sig { params(zorki_user: Zorki::User).returns(Hash) }
  def self.instagram_user_hash_from_zorki_user(zorki_user)
    {
      handle:              zorki_user.username,
      display_name:        zorki_user.name,
      number_of_posts:     zorki_user.number_of_posts,
      followers_count:     zorki_user.number_of_followers,
      following_count:     zorki_user.number_of_following,
      verified:            zorki_user.verified,
      profile:             zorki_user.profile,
      url:                 zorki_user.profile_link,
      profile_image_url:   zorki_user.profile_image_url,
      profile_image:       File.open(zorki_user.profile_image, "rb"),
    }
  end
end
