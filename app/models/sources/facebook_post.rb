# typed: strict

class Sources::FacebookPost < ApplicationRecord
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

  has_many :images, foreign_key: :facebook_post_id, class_name: "MediaModels::Images::FacebookImage", dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true

  has_many :videos, foreign_key: :facebook_post_id, class_name: "MediaModels::Videos::FacebookVideo", dependent: :destroy
  accepts_nested_attributes_for :videos, allow_destroy: true

  # The `FacebookUser` that is the author of this tweet.
  belongs_to :author, class_name: "FacebookUser"

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
    FacebookMediaSource.send(:validate_facebook_post_url, url)
  rescue FacebookMediaSource::InvalidFacebookPostUrlError
    false
  end

  # Returns the scrape type for the +Scrapable+ concernt
  #
  # @!scope class
  # @returns [MediaSource::ScrapeType] the type of scrape that this class is
  sig { returns(MediaSource::ScrapeType) }
  def self.scrape_type
    MediaSource::ScrapeType::Facebook
  end

  # Create a +ArchiveItem+ from a +url+ as a string. Skips Hypatia's queue.
  #
  # @!scope class
  # @params url String a string of a url
  # @params user The user adding the ArchiveItem
  # returns ArchiveItem
  sig { params(url: String, user: T.nilable(User), initiated_from: Integer).returns(ArchiveItem) }
  def self.create_from_url!(url, user = nil, initiated_from: nil)
    raise "You have to start from somewhere.... (No inititated_from submitted)" if initiated_from.nil?

    forki_response = FacebookMediaSource.extract(url, MediaSource::ScrapeType::Facebook, true, initiated_from)
    raise "Error sending job to Forki" unless forki_response.has_key?("scrape_result") &&
        forki_response["scrape_result"].respond_to?(:first) &&
        forki_response["scrape_result"].first.has_key?("id")

    Sources::FacebookPost.create_from_forki_hash(forki_response["scrape_result"], user).first
  end

  # A generically-named alias for create_from_forki_hash used for model-agnostic method calls
  # @params forki_posts [Array[Forki:ForkiPost]] an array of Facebook posts grabbed from Forki
  # @returns [Array[ArchiveItem]] an array of ArchiveItems with type FacebbokPost that have been
  #    saved to the graph database
  sig { params(forki_posts: T::Array[Hash], user: T.nilable(User)).returns(T::Array[ArchiveItem]) }
  def self.create_from_hash(forki_posts, user = nil)
    create_from_forki_hash(forki_posts, user)
  end

  # Create a +ArchiveItem+ from a +Forki::Post+
  #
  # @!scope class
  # @params forki_posts [Array[Forki::Post]] an array of Facebook posts grabbed from Forki
  # @returns [Array[ArchiveItem]] an array of ArchiveItem with type Tweet that have been
  #   saved to the graph database
  sig { params(forki_posts: T::Array[Hash], user: T.nilable(User)).returns(T::Array[ArchiveItem]) }
  def self.create_from_forki_hash(forki_posts, user = nil)
    forki_posts.map do |forki_post|
      forki_post = forki_post["post"]
      facebook_user = Sources::FacebookUser.create_from_forki_hash([forki_post["user"]]).first.facebook_user

      image_attributes = []
      video_attributes = []
      screenshot_attributes = {}

      # We want to default to using the AWS key if it's available, and fallback to Base64 if it's not
      if forki_post["aws_screenshot_key"].present?
        downloaded_path = AwsS3Downloader.download_file_in_s3_received_from_hypatia(forki_post["aws_screenshot_key"])
        screenshot_attributes = { image: File.open(downloaded_path, binmode: true) }
      else
        tempfile = Tempfile.new(binmode: true)
        tempfile.write(Base64.decode64(forki_post["screenshot_file"]))
        screenshot_attributes = { image: File.open(tempfile.path, binmode: true) }
        tempfile.close!
      end

      if forki_post["aws_image_keys"].present?
        downloaded_path = AwsS3Downloader.download_file_in_s3_received_from_hypatia(forki_post["aws_image_keys"])
        image_attributes = [ { image: File.open(downloaded_path, binmode: true) } ]
      elsif forki_post["aws_video_keys"].present?
        video_attributes = forki_post["aws_video_keys"].map do |key|
          downloaded_path = AwsS3Downloader.download_file_in_s3_received_from_hypatia(key)
          { video: File.open(downloaded_path, binmode: true) }
        end
      elsif forki_post["aws_video_key"].present?
        downloaded_path = AwsS3Downloader.download_file_in_s3_received_from_hypatia(forki_post["aws_video_key"])
        video_attributes = [ { video: File.open(downloaded_path, binmode: true) } ]
      else
        # Backwards compatibility for if Hypatia sends over files in Base64
        unless forki_post["image_file"].blank?
          tempfile = Tempfile.new(binmode: true)
          tempfile.write(Base64.decode64(forki_post["image_file"]))
          image_attributes = [ { image: File.open(tempfile.path, binmode: true) } ]
          tempfile.close!
        end

        # Backwards compatibility for if Hypatia sends over files in Base64
        unless forki_post["video_file"].blank?
          tempfile = Tempfile.new(binmode: true)
          tempfile.write(Base64.decode64(forki_post["video_file"]))
          video_attributes = [{ video: File.open(tempfile.path, binmode: true) }]
          tempfile.close!
        end
      end

      created_at_time = forki_post["created_at"].nil? ? nil : Time.at(forki_post["created_at"])

      hash = {
        url:               forki_post["url"],
        text:              forki_post["text"],
        facebook_id:       forki_post["id"],
        posted_at:         created_at_time,
        reactions:         forki_post["reactions"],
        num_comments:      forki_post["num_comments"],
        num_shares:        forki_post["num_shares"],
        num_views:         forki_post["num_views"],
        author:            facebook_user,
        images_attributes: image_attributes,
        videos_attributes: video_attributes
      }

      ArchiveItem.create!(archivable_item: Sources::FacebookPost.create!(hash), submitter: user,
                          screenshot_attributes: screenshot_attributes)
    end
  end

  # Get the `service_id` of the Instagram Post, in this case the id that Instagram provides
  #
  # @returns String of the ID.
  sig { returns(String) }
  def service_id
    facebook_id
  end

  sig { returns(Integer) }
  def number_of_likes
    reactions["num_likes"]
  end

  sig { returns(Integer) }
  def number_of_haha_reactions
    reactions["num_hahas"]
  end

  sig { returns(Integer) }
  def number_of_angry_reactions
    reactions["num_angrys"]
  end

  sig { returns(Integer) }
  def number_of_love_reactions
    reactions["num_loves"]
  end

  sig { returns(Integer) }
  def number_of_care_reactions
    reactions["num_cares"]
  end

  sig { returns(Integer) }
  def number_of_sad_reactions
    reactions["num_sads"]
  end
  # Normalized representation of this archivable item for use in the view template.
  #
  # @returns Hash of normalized attributes.
  sig { returns(Hash) }
  def normalized_attrs_for_views
    {
      publishing_platform_shortname:    "facebook",
      publishing_platform_display_name: "Facebook",
      author_canonical_path:            url_helpers.media_vault_author_path(self.author, platform: :facebook),
      author_profile_image_url:         self.author.profile_image_url,
      author_display_name:              self.author.name,
      author_username:                  nil,
      author_community_count:           self.author.followers_count,
      author_community_noun:            "follower",
      archive_item_self:                self,
      archive_item_caption:             self.text,
      published_at:                     self.posted_at,
    }
  end
end
