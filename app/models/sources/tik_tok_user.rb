class Sources::TikTokUser < ApplicationRecord
  include ArchivableEntity
  include ImageUploader::Attachment(:profile_image) # adds an `image` virtual attribute
  include PgSearch::Model

  multisearchable against: [:handle, :display_name]

  # The tweets that an TikTokUser have authored
  has_many :tik_tok_posts, foreign_key: :author_id, dependent: :destroy

  # Create an +TikTokUser+ from a +Zorki::User+
  #
  # @!scope class
  # @params birdsong_users [Array[Zorki:User]] an array of tweets grabbed from Zorki
  # @returns [Array[ArchiveEntity]] an array of +ArchiveEntity+ with type of TikTokUser that have been
  #   saved
  sig { params(morris_users: T::Array[Hash]).returns(T::Array[ArchiveEntity]) }
  def self.create_from_morris_hash(morris_users)
    morris_users.map do |morris_user|
      # First check if the user already exists, if so, return that
      tiktok_user = Sources::TikTokUser.find_by(handle: morris_user["username"])
      morris_user_hash = self.tiktok_user_hash_from_morris_user(morris_user)

      # If there's no user, then create it
      if tiktok_user.nil?
        user = Sources::TikTokUser.create!(morris_user_hash)
        tiktok_user = ArchiveEntity.create! archivable_entity: user
      else
        # Update TikTok user with the new data
        #
        # Question: do we want to version this at some point so we can tell what the user had when
        # it was accessed at any given time?
        tiktok_user.update!(morris_user_hash)

        # We return the ArchiveEntity, because it's expected
        tiktok_user = tiktok_user.archive_entity
      end

      tiktok_user
    end
  end

  # The unique service id for this item
  #
  # @returns String the id assigned by TikTok to this user
  sig { returns(String) }
  def service_id
    handle
  end

  # The platform that this author is associated with.
  #
  # @returns String of the platform name
  sig { returns(String) }
  def platform
    "tiktok"
  end

private

  # Create a hash from a Zorki::User suitable for a new TikTokUser or updating one
  #
  # @!scope class
  # @!visibility private
  # @params birdsong_users Zorki:User an tweet grabbed from Zorki
  # @returns Hash a data structure suitable to pass to `create` or `update`
  sig { params(morris_user: Hash).returns(Hash) }
  def self.tiktok_user_hash_from_morris_user(morris_user)
    # If the requisite object key is present, download the user's profile image from s3
    if morris_user.has_key?("aws_profile_image_key") && !morris_user["aws_profile_image_key"].blank?
      profile_image_path = AwsS3Downloader.download_file_in_s3_received_from_hypatia(morris_user["aws_profile_image_key"])
    else
      # We create a temp file and write the image data to it, which yea, is dumb,
      # and there may be a better way to do it, but this works to fix the encoding issues
      # (basically, when we call `create` later, Rails tries to convert the string into UTF-8
      # which obviously breaks everything)
      tempfile = Tempfile.new(binmode: true)
      tempfile.write(Base64.decode64(morris_user["profile_image"]))
      profile_image_path = tempfile.path
      tempfile.close!
    end

    hash_to_return = {
      handle:              morris_user["username"],
      display_name:        morris_user["name"],
      number_of_posts:     morris_user["number_of_posts"],
      followers_count:     morris_user["number_of_followers"],
      following_count:     morris_user["number_of_following"],
      verified:            morris_user["verified"],
      profile:             morris_user["profile"],
      url:                 morris_user["profile_link"],
      profile_image_url:   morris_user["profile_image_url"],
      profile_image:       File.open(profile_image_path, binmode: true)
    }

    hash_to_return
  end
end
