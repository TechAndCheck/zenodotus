# typed: strict

class Sources::InstagramPost < ApplicationRecord
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

  has_many :images, foreign_key: :instagram_post_id, class_name: "MediaModels::Images::InstagramImage", dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true

  has_many :videos, foreign_key: :instagram_post_id, class_name: "MediaModels::Videos::InstagramVideo", dependent: :destroy
  accepts_nested_attributes_for :videos, allow_destroy: true

  # has_one :media_review, foreign_key: :archive_item_id, class_name: "MediaReview", dependent: :destroy

  # The `TwitterUser` that is the author of this tweet.
  belongs_to :author, class_name: "InstagramUser"

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
    InstagramMediaSource.send(:validate_instagram_post_url, url)
  rescue InstagramMediaSource::InvalidInstagramPostUrlError
    false
  end

  # Create an +ArchiveItem+ from a +url+ as a string
  #
  # @!scope class
  # @params url String a string of a url
  # @params user User: the user creating an ArchiveItem
  # returns ArchiveItem with type InstagramPost that has been saved to the database
  sig { params(url: String, user: T.nilable(User), initiated_from: Integer).returns(ArchiveItem) }
  def self.create_from_url!(url, user = nil, initiated_from: nil)
    raise "You have to start from somewhere.... (No inititated_from submitted)" if initiated_from.nil?

    zorki_response = InstagramMediaSource.extract(url, MediaSource::ScrapeType::Instagram, true, initiated_from)["scrape_result"]
    raise "Error sending job to Zorki" unless zorki_response.respond_to?(:first) && zorki_response.first.has_key?("id")
    Sources::InstagramPost.create_from_zorki_hash(zorki_response, user).first
  end

  # Returns the scrape type for the +Scrapable+ concernt
  #
  # @!scope class
  # @returns [MediaSource::ScrapeType] the type of scrape that this class is
  sig { returns(MediaSource::ScrapeType) }
  def self.scrape_type
    MediaSource::ScrapeType::Instagram
  end

  # An alias for create_from_zorki_hash painted with a generic name so it can be called in a model agnostic fashion
  # @params zorki_posts [Array[Zorki:Post]] an array of Instagram Posts grabbed from Zorki
  # @returns [Array[ArchiveItem]] an array of ArchiveItem with type Tweet that have been
  #   saved to the graph database
  sig { params(zorki_posts: T::Array[Hash], user: T.nilable(User)).returns(T::Array[ArchiveItem]) }
  def self.create_from_hash(zorki_posts, user = nil)
    create_from_zorki_hash(zorki_posts, user)
  end

  # Create a +ArchiveItem+ from a +Zorki::Post+
  #
  # @!scope class
  # @params birdsong_tweets [Array[Zorki::Post]] an array of tweets grabbed from Birdsong
  # @params user User the current user creating an ArchiveItem
  # @returns [Array[ArchiveItem]] an array of ArchiveItem with type Tweet that have been
  #   saved to the graph database
  sig { params(zorki_posts: T::Array[Hash], user: T.nilable(User)).returns(T::Array[ArchiveItem]) }
  def self.create_from_zorki_hash(zorki_posts, user = nil)
    zorki_posts.map do |zorki_post|
      zorki_post = zorki_post["post"]
      user_json = zorki_post["user"]
      instagram_user = Sources::InstagramUser.create_from_zorki_hash([user_json]).first.instagram_user

      image_attributes = []
      video_attributes = []
      screenshot_attributes = {}

      if zorki_post["aws_screenshot_key"].present?
        downloaded_path = AwsS3Downloader.download_file_in_s3_received_from_hypatia(zorki_post["aws_screenshot_key"])
        screenshot_attributes = { image: File.open(downloaded_path, binmode: true) }
      else
        tempfile = Tempfile.new(binmode: true)
        tempfile.write(Base64.decode64(zorki_post["screenshot_file"]))
        screenshot_attributes = { image: File.open(tempfile.path, binmode: true) }
        tempfile.close!
      end

      if zorki_post["aws_image_keys"].present?
        image_attributes = zorki_post["aws_image_keys"].map do |key|
          downloaded_path = AwsS3Downloader.download_file_in_s3_received_from_hypatia(key)
          { image: File.open(downloaded_path, binmode: true) }
        end
      elsif zorki_post["aws_video_key"].present?
        downloaded_path = AwsS3Downloader.download_file_in_s3_received_from_hypatia(zorki_post["aws_video_key"])
        video_attributes = [ { video: File.open(downloaded_path, binmode: true) } ]
      else
        # Backwards compatibility for if Hypatia sends over files in Base64
        unless zorki_post["image_files"].nil?
          image_attributes = zorki_post["image_files"].map do |image_file_data|
            tempfile = Tempfile.new(binmode: true)
            tempfile.write(Base64.decode64(image_file_data))
            image_attribute = { image: File.open(tempfile.path, binmode: true) }
            tempfile.close!
            image_attribute
          end
        end

        unless zorki_post["video_file"].nil?
          tempfile = Tempfile.new(binmode: true)
          tempfile.write(Base64.decode64(zorki_post["video_file"]))
          video_attributes = [{ video: File.open(tempfile.path, binmode: true) }]
          tempfile.close!
        end
      end

      hash = {
        text:              zorki_post["text"],
        instagram_id:      zorki_post["id"],
        posted_at:         zorki_post["date"],
        number_of_likes:   zorki_post["number_of_likes"],
        author:            instagram_user,
        images_attributes: image_attributes,
        videos_attributes: video_attributes
      }


      ArchiveItem.create!(archivable_item: Sources::InstagramPost.create!(hash), submitter: user,
                          screenshot_attributes: screenshot_attributes)
    end
  end

  # Get the `service_id` of the Instagram Post, in this case the id that Instagram provides
  #
  # @returns String of the ID.
  sig { returns(String) }
  def service_id
    instagram_id
  end

  # Returns a reconstructed url as a +string+ since we don't store the full url in the database
  #
  # @returns a string of the url
  sig { returns(String) }
  def url
    "https://www.instagram.com/p/#{instagram_id}/"
  end

  # Normalized representation of this archivable item for use in the view template.
  #
  # @returns Hash of normalized attributes.
  sig { returns(Hash) }
  def normalized_attrs_for_views
    {
      publishing_platform_shortname:    "instagram",
      publishing_platform_display_name: "Instagram",
      author_canonical_path:            url_helpers.media_vault_author_path(self.author, platform: :instagram),
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
end
