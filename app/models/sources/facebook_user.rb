# typed: strict

class Sources::FacebookUser < ApplicationRecord
  include ArchivableEntity
  include ImageUploader::Attachment(:profile_image) # adds an `image` virtual attribute
  include PgSearch::Model

  multisearchable against: :name
  # The tweets that an FacebookUser have authored
  has_many :facebook_posts, class_name: "Sources::FacebookPost", foreign_key: :author_id, dependent: :destroy

  # Create a +FacebookUser+ from a +Forki::User+
  #
  # @!scope class
  # @params forki_users [Array[Forki:User]] an array of user hashes grabbed from Forki
  # @returns [Array[ArchiveEntity]] an array of +ArchiveEntity+ with type of FacebookUser that have been
  #   saved
  sig { params(forki_users: T::Array[Hash]).returns(T::Array[ArchiveEntity]) }
  def self.create_from_forki_hash(forki_users)
    forki_users.map do |forki_user|
      # First check if the user already exists, if so, return that
      facebook_user = Sources::FacebookUser.find_by(facebook_id: forki_user["id"])
      forki_user_hash = self.facebook_user_hash_from_forki_user(forki_user)

      # If there's no user, then create it
      if facebook_user.nil?
        user = Sources::FacebookUser.create!(forki_user_hash)
        facebook_user = ArchiveEntity.create! archivable_entity: user
      else
        # Update Facebook user with the new data
        #
        # Question: do we want to version this at some point so we can tell what the user had when
        # it was accessed at any given time?
        facebook_user.update!(forki_user_hash)

        # We return the ArchiveEntity, because it's expected
        facebook_user = facebook_user.archive_entity
      end

      facebook_user
    end
  end

  # The unique service id for this item
  #
  # @returns String the id assigned by Facebook to this user
  sig { returns(String) }
  def service_id
    facebook_id
  end

  # The platform that this author is associated with.
  #
  # @returns String of the platform name
  sig { returns(String) }
  def platform
    "facebook"
  end

  private

    # Create a hash from a Forki::User suitable for a new FacebookUser or updating one
    #
    # @!scope class
    # @!visibility private
    # @params forki_user Forki:User
    # @returns Hash a data structure suitable to pass to `create` or `update`
    sig { params(forki_user: Hash).returns(Hash) }
    def self.facebook_user_hash_from_forki_user(forki_user)
      # If the requisite object key is present, download the user's profile image from s3
      if forki_user.has_key?("aws_profile_image_key")
        profile_image_path = AwsS3Downloader.download_file_in_s3_received_from_hypatia(forki_user["aws_profile_image_key"])
      else
        # We create a temp file and write the image data to it, which yea, is dumb,
        # and there may be a better way to do it, but this works to fix the encoding issues
        # (basically, when we call `create` later, Rails tries to convert the string into UTF-8
        # which obviously breaks everything)
        tempfile = Tempfile.new(binmode: true)
        tempfile.write(Base64.decode64(forki_post["profile_image"]))
        profile_image_path = tempfile.path
        tempfile.close!
      end

      hash_to_return = {
        facebook_id:         forki_user["id"],
        name:                forki_user["name"],
        profile:             forki_user["profile"],
        followers_count:     forki_user["number_of_followers"],
        likes_count:         forki_user["number_of_likes"],
        verified:            forki_user["verified"],
        url:                 forki_user["profile_link"],
        profile_image_url:   forki_user["profile_image_url"],
        profile_image:       File.open(profile_image_path, binmode: true)
      }
      hash_to_return
    end
end
