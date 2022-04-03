# typed: strict

class Sources::YoutubeChannel < ApplicationRecord
  include ArchivableEntity
  include ImageUploader::Attachment(:channel_image) # adds an `image` virtual attribute
  include PgSearch::Model

  multisearchable against: [:title]

  # The tweets that a TwitterUser have authored
  has_many :youtube_posts, foreign_key: :channel_id, dependent: :destroy

  # Create a +YoutubeChannel+ from a +YoutubeArchiver::Channel+
  #
  # @!scope class
  # @params youtube_archiver_channels [Array[Hash] an array of Youtube videos grabbed from YoutubeArchiver
  # @returns [Array[ArchiveEntity]] an array of +ArchiveEntity+ with type of TwitterUser that have been
  #   saved
  sig { params(youtube_archiver_channels: T::Array[Hash]).returns(T::Array[ArchiveEntity]) }
  def self.create_from_youtube_archiver_hash(youtube_archiver_channels)
    youtube_archiver_channels.map do |channel|
      # First check if the user already exists, if so, return that
      youtube_channel = Sources::YoutubeChannel.find_by(youtube_id: channel["id"])
      youtube_channel_hash  = self.youtube_channel_hash_from_youtube_archiver_channel(channel)

      # If there's no channel, then create it
      if youtube_channel.nil?
        youtube_channel = ArchiveEntity.create! archivable_entity: Sources::YoutubeChannel.create(youtube_channel_hash)
      else
        # Update Youtube Channel with the new data
        #
        # Question: do we want to version this at some point so we can tell what the user had when
        # it was accessed at any given time?
        youtube_channel.update!(youtube_channel_hash)

        # We return the ArchiveEntity, because it's expected
        youtube_channel = youtube_channel.archive_entity
      end

      youtube_channel
    end
  end

  # The unique service id for this item
  #
  # @returns String the id assigned by YouTube to this user
  sig { returns(String) }
  def service_id
    youtube_id
  end

private

  # Create a hash from a YoutubeArchiver::Channel suitable for a new YoutubeChannel or updating one
  #
  # @!scope class
  # @!visibility private
  # @params youtube_archiver_channels YoutubeArchiver:Channel a YouTu grabbed from Birdsong
  # @returns Hash a data structure suitable to pass to `create` or `update`
  sig { params(youtube_archiver_channel: Hash).returns(Hash) }
  def self.youtube_channel_hash_from_youtube_archiver_channel(youtube_archiver_channel)
    tempfile = Tempfile.new(binmode: true)
    tempfile.write(Base64.decode64(youtube_archiver_channel["channel_image_file"]))

    {
      youtube_id: youtube_archiver_channel["id"],
      title: youtube_archiver_channel["title"],
      sign_up_date: youtube_archiver_channel["created_at"],
      description: youtube_archiver_channel["description"],
      num_views: youtube_archiver_channel["view_count"],
      num_subscribers: youtube_archiver_channel["subscriber_count"],
      num_videos: youtube_archiver_channel["video_count"],
      made_for_kids: youtube_archiver_channel["made_for_kids"],
      channel_image: File.open(tempfile.path, binmode: true)
    }
  end
end
