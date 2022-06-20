# typed: strict

# We're calling these YoutubePosts so we can refer to the associated media model as YoutubeVideos
class Sources::YoutubePost < ApplicationRecord
  include ArchivableItem
  include PgSearch::Model
  include ImageUploader::Attachment(:preview_image) # adds an `image` virtual attribute

  multisearchable against: :title

  has_many :videos, foreign_key: :youtube_post_id, class_name: "MediaModels::Videos::YoutubeVideo", dependent: :destroy
  accepts_nested_attributes_for :videos, allow_destroy: true

  # The `YoutubeChannel` that is the author of this tweet.
  belongs_to :author, foreign_key: :channel_id, class_name: "YoutubeChannel"

  after_commit on: [:create] do
    # We only want to create the derivatives once (since you know, it's a media archive we don't
    # want them to change)
    # self.video.video_derivatives!
    self.videos.each { |video| video.video_derivatives! }
  end

  # Returns a +boolean+ on whether this class can handle the URL passed in.
  # All items that are scraped should implement this class
  #
  # @!scope class
  # @params url String a url for an object to check
  # @return a Boolean on whether or not the class can handle the URL
  sig { params(url: String).returns(T::Boolean) }
  def self.can_handle_url?(url)
    YoutubeMediaSource.send(:validate_youtube_post_url, url)
  rescue YoutubeMediaSource::InvalidYoutubePostUrlError
    false
  end

  # Spawns an ActiveJob tasked with creating an +ArchiveItem+ from a +url+ as a string
  #
  # @!scope class
  # @params url String a string of a url
  # @params user the user adding the ArchiveItem
  # returns ScraperJob
  sig { params(url: String, user: T.nilable(User)).returns(ScraperJob) }
  def self.create_from_url(url, user = nil)
    ScraperJob.perform_later(YoutubeMediaSource, Sources::YoutubePost, url, user)
  end

  # Create a +ArchiveItem+ from a +url+ as a string. Skips Hypatia's queue.
  #
  # @!scope class
  # @params url String a string of a url
  # @params user The user adding the ArchiveItem
  # returns ArchiveItem
  sig { params(url: String, user: T.nilable(User)).returns(ArchiveItem) }
  def self.create_from_url!(url, user = nil)
    youtube_archiver_response = YoutubeMediaSource.extract(url, true)["scrape_result"]
    raise "Error sending job to YoutubeArchiver" unless youtube_archiver_response.respond_to?(:first) && youtube_archiver_response.first.has_key?("id")
    Sources::YoutubePost.create_from_youtube_archiver_hash(youtube_archiver_response, user).first
  end

  # A generically-named alias for create_from_youtube_archiver_hash used for model-agnostic method calls
  # @params youtubearchiver_videos [Array[YoutubeArchiver:Video]] an array of Youtube Videos grabbed from YoutubeArchiver
  # @returns [Array[ArchiveItem]] an array of ArchiveItems with type YoutubePost that have been
  #    saved to the graph database
  sig { params(youtube_archiver_videos: T::Array[Hash], user: T.nilable(User)).returns(T::Array[ArchiveItem]) }
  def self.create_from_hash(youtube_archiver_videos, user = nil)
    create_from_youtube_archiver_hash(youtube_archiver_videos, user)
  end

  # Find the number of seconds in a YouTube duration string
  # @ params duration_string [String] A string following the pattern PT#H#M#S, where # is an integer
  # @ returns [Integer] Number of seconds
  sig { params(duration_string: String).returns(Integer) }
  def self.find_length_of_youtube_video(duration_string)
    if /PT((\d+)H)?((\d+)M)?((\d+)S)?/ =~ duration_string
      $2.to_i * 3600 + $4.to_i * 60 + $6.to_i
    else
      0
    end
  end

  # Create a +ArchiveItem+ from a +Forki::Post+
  #
  # @!scope class
  # @params youtube_archiver_videos [Array[Forki::Post]] an array of Facebook posts grabbed from Forki
  # @returns [Array[ArchiveItem]] an array of ArchiveItem with type Tweet that have been
  #   saved to the graph database
  sig { params(youtube_archiver_videos: T::Array[Hash], user: T.nilable(User)).returns(T::Array[ArchiveItem]) }
  def self.create_from_youtube_archiver_hash(youtube_archiver_videos, user = nil)
    youtube_archiver_videos.map do |youtube_archiver_video|
      youtube_archiver_video = youtube_archiver_video["post"]
      youtube_channel = Sources::YoutubeChannel.create_from_youtube_archiver_hash([youtube_archiver_video["channel"]]).first.youtube_channel
      if youtube_archiver_video["aws_video_key"].present?
        downloaded_path = AwsS3Downloader.download_file_in_s3_received_from_hypatia(youtube_archiver_video["aws_video_key"])
        videos_attributes = [ { video: File.open(downloaded_path, binmode: true) } ]
      elsif youtube_archiver_video["video_file"].nil? == false
        tempfile = Tempfile.new(binmode: true)
        tempfile.write(Base64.decode64(youtube_archiver_video["video_file"]))

        videos_attributes = [{ video: File.open(tempfile.path, binmode: true) }]

        tempfile.close!
      else
        videos_attributes = []
      end

      tempfile = Tempfile.new(binmode: true)
      tempfile.write(Base64.decode64(youtube_archiver_video["video_preview_image_file"]))

      hash = {
        youtube_id:        youtube_archiver_video["id"],
        title:             youtube_archiver_video["title"],
        num_views:         youtube_archiver_video["num_views"],
        num_likes:         youtube_archiver_video["num_likes"],
        num_comments:      youtube_archiver_video["num_comments"],
        posted_at:         youtube_archiver_video["created_at"],
        language:          youtube_archiver_video["language"],
        duration:          find_length_of_youtube_video(youtube_archiver_video["duration"]),
        live:              youtube_archiver_video["live"],
        author:            youtube_channel,
        preview_image:     File.open(tempfile.path, binmode: true),
        made_for_kids:     youtube_archiver_video["made_for_kids"],
        videos_attributes: videos_attributes
      }

      ArchiveItem.create!(archivable_item: Sources::YoutubePost.create!(hash), submitter: user)
    end
  end

  # Get the `service_id` of the Youtuve Video, in this case the id that Youtube provides
  #
  # @returns String of the ID.
  sig { returns(String) }
  def service_id
    youtube_id
  end

  # Normalized representation of this archivable item for use in the view template.
  #
  # @returns Hash of normalized attributes.
  sig { returns(Hash) }
  def normalized_attrs_for_views
    {
      publishing_platform_shortname:    "youtube",
      publishing_platform_display_name: "YouTube",
      author_canonical_path:            url_helpers.youtube_channel_path(self.author),
      author_profile_image_url:         self.author.channel_image_url,
      author_display_name:              self.author.title,
      author_username:                  nil,
      author_community_count:           self.author.num_subscribers,
      author_community_noun:            "subscriber",
      archive_item_self:                self,
      archive_item_caption:             self.title,
      published_at:                     self.posted_at,
    }
  end

  # This is a filler for the `images` property that normally wouldn't exist
  #
  # @return Array that's empty
  sig { returns(Array) }
  def images
    []
  end
end
