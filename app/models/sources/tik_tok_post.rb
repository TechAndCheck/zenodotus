class Sources::TikTokPost < ApplicationRecord
  include ArchivableItem
  include PgSearch::Model
  include Scrapable

  multisearchable(
    against: :text,
    additional_attributes: -> (post) { {
      private: post.archive_item.nil? ? false : post.archive_item.private, # Messy but meh
      user_id: post.archive_item&.users&.map(&:id)
    } }
  )

  has_many :videos, foreign_key: :tik_tok_post_id, class_name: "MediaModels::Videos::TikTokVideo", dependent: :destroy
  accepts_nested_attributes_for :videos, allow_destroy: true

  # The `TwitterUser` that is the author of this tweet.
  belongs_to :author, class_name: "TikTokUser"

  after_commit on: [:create] do
    # We only want to create the derivatives once (since you know, it's a media archive we don't
    # want them to change)
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
    TikTokMediaSource.send(:validate_tiktok_post_url, url)
  rescue TikTokMediaSource::InvalidTikTokPostUrlError
    false
  end

  # Create an +ArchiveItem+ from a +url+ as a string
  #
  # @!scope class
  # @params url String a string of a url
  # @params user User: the user creating an ArchiveItem
  # returns ArchiveItem with type TikTokPost that has been saved to the database
  sig { params(url: String, user: T.nilable(User)).returns(ArchiveItem) }
  def self.create_from_url!(url, user = nil)
    morris_response = TikTokMediaSource.extract(url, MediaSource::ScrapeType::TikTok, true)["scrape_result"]
    raise "Error sending job to Morris" unless morris_response.respond_to?(:first) && morris_response.first.has_key?("id")
    Sources::TikTokPost.create_from_morris_hash(morris_response, user).first
  end

  # Returns the scrape type for the +Scrapable+ concernt
  #
  # @!scope class
  # @returns [MediaSource::ScrapeType] the type of scrape that this class is
  sig { returns(MediaSource::ScrapeType) }
  def self.scrape_type
    MediaSource::ScrapeType::TikTok
  end

  # An alias for create_from_morris_hash painted with a generic name so it can be called in a model agnostic fashion
  # @params morris_posts [Array[Morris:Post]] an array of TikTok Posts grabbed from Morris
  # @returns [Array[ArchiveItem]] an array of ArchiveItem with type Tweet that have been
  #   saved to the graph database
  sig { params(morris_posts: T::Array[Hash], user: T.nilable(User)).returns(T::Array[ArchiveItem]) }
  def self.create_from_hash(morris_posts, user = nil)
    create_from_morris_hash(morris_posts, user)
  end

  # Create a +ArchiveItem+ from a +Morris::Post+
  #
  # @!scope class
  # @params birdsong_tweets [Array[Morris::Post]] an array of tweets grabbed from Birdsong
  # @params user User the current user creating an ArchiveItem
  # @returns [Array[ArchiveItem]] an array of ArchiveItem with type Tweet that have been
  #   saved to the graph database
  sig { params(morris_posts: T::Array[Hash], user: T.nilable(User)).returns(T::Array[ArchiveItem]) }
  def self.create_from_morris_hash(morris_posts, user = nil)
    morris_posts.map do |morris_post|
      user_json = morris_post["post"]["user"]
      tiktok_user = Sources::TikTokUser.create_from_morris_hash([user_json]).first.tiktok_user

      video_attributes = []
      screenshot_attributes = {}

      if morris_post["post"]["aws_screenshot_key"].present?
        downloaded_path = AwsS3Downloader.download_file_in_s3_received_from_hypatia(morris_post["post"]["aws_screenshot_key"])
        screenshot_attributes = { image: File.open(downloaded_path, binmode: true) }
      else
        tempfile = Tempfile.new(binmode: true)
        tempfile.write(Base64.decode64(morris_post["post"]["screenshot_file"]))
        screenshot_attributes = { image: File.open(tempfile.path, binmode: true) }
        tempfile.close!
      end

      if morris_post["post"]["aws_video_key"].present?
        downloaded_path = AwsS3Downloader.download_file_in_s3_received_from_hypatia(morris_post["post"]["aws_video_key"])
        video_attributes = [ { video: File.open(downloaded_path, binmode: true) } ]
      end

      hash = {
        text:              morris_post["post"]["text"],
        tik_tok_id:      morris_post["id"],
        posted_at:         morris_post["post"]["date"],
        number_of_likes:   morris_post["post"]["number_of_likes"],
        author:            tiktok_user,
        videos_attributes: video_attributes
      }

      ArchiveItem.create!(archivable_item: Sources::TikTokPost.create!(hash), submitter: user,
                          screenshot_attributes: screenshot_attributes)
    end
  end

  # Get the `service_id` of the TikTok Post, in this case the id that TikTok provides
  #
  # @returns String of the ID.
  sig { returns(String) }
  def service_id
    tik_tok_id
  end

  # Normalized representation of this archivable item for use in the view template.
  #
  # @returns Hash of normalized attributes.
  sig { returns(Hash) }
  def normalized_attrs_for_views
    {
      publishing_platform_shortname:    "tiktok",
      publishing_platform_display_name: "TikTok",
      author_canonical_path:            url_helpers.media_vault_author_path(self.author, platform: :tiktok),
      author_profile_image_url:         self.author.profile_image_url,
      author_display_name:              self.author.display_name,
      author_username:                  self.author.handle,
      author_community_count:           self.author.followers_count,
      author_community_noun:            "follower",
      archive_item_self:                self,
      archive_item_caption:             self.text,
      published_at:                     self.posted_at,
    }
  end

  def images
    []
  end
end
