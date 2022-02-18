# typed: strict

class Sources::FacebookPost < ApplicationRecord
  include ArchivableItem
  include PgSearch::Model

  multisearchable against: :text

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

  # Spawns an ActiveJob tasked with creating an +ArchiveItem+ from a +url+ as a string
  #
  # @!scope class
  # @params url String a string of a url
  # @params user the user adding the ArchiveItem
  # returns ArchiveItem with type InstagramPost that have been
  #   saved to the graph database
  sig { params(url: String, user: T.nilable(User)).returns(ArchiveItem) }
  def self.create_from_url(url, user = nil)
    ScraperJob.perform_later(FacebookMediaSource, Sources::FacebookPost, url, user)
  end

  # Create a +ArchiveItem+ from a +url+ as a string. Skips Hypatia's queue. 
  #
  # @!scope class
  # @params url String a string of a url
  # @params user The user adding the ArchiveItem
  # returns ScraperJob
  sig { params(url: String, user: T.nilable(User)).returns(ScraperJob) }
  def self.create_from_url!(url, user = nil)
    forki_response = FacebookMediaSource.extract(url, force=true)
    raise "Error sending job to Forki" unless forki_response.respond_to?(:first) && forki_response.first.has_key?("id")
    Sources::FacebookPost.create_from_forki_hash(forki_response, user).first
  end

  # A generically-named alias for create_from_forki_hash used for model-agnostic method calls
  # @params forki_posts [Array[Forki:ForkiPost]] an array of Facebook posts grabbed from Forki
  # @returns [Array[ArchiveItem]] an array of ArchiveItems with type FacebbokPost that have been
  #    saved to the graph database
  sig { params(forki_posts: T::Array[Hash], user: T.nilable(User)).returns(T::Array[ArchiveItem]) }
  def self.create_from_hash(forki_posts, user)
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
      facebook_user = Sources::FacebookUser.create_from_forki_hash([forki_post["user"]]).first.facebook_user

      unless forki_post["image_file"].nil?
        # image_attributes = forki_post["image_files"].map do |image_file_data|
        tempfile = Tempfile.new(binmode: true)
        tempfile.write(Base64.decode64(forki_post["image_file"]))

        image_attributes = [ { image: File.open(tempfile.path, binmode: true) } ]

        tempfile.close!
        # end
      else
        image_attributes = []
      end

      unless forki_post["video_file"].nil?
        tempfile = Tempfile.new(binmode: true)
        tempfile.write(Base64.decode64(forki_post["video_file"]))

        video_attributes = [{ video: File.open(tempfile.path, binmode: true) }]

        tempfile.close!
        video_attributes
      else
        video_attributes = []
      end

      hash = {
        url:               forki_post["url"],
        text:              forki_post["text"],
        facebook_id:       forki_post["id"],
        posted_at:         Time.at(forki_post["created_at"]),
        reactions:         forki_post["reactions"],
        num_comments:      forki_post["num_comments"],
        num_shares:        forki_post["num_shares"],
        num_views:         forki_post["num_views"],
        author:            facebook_user,
        images_attributes: image_attributes,
        videos_attributes: video_attributes
      }

      ArchiveItem.create!(archivable_item: Sources::FacebookPost.create!(hash), submitter: user)
    end
  end

  # Get the `service_id` of the Instagram Post, in this case the id that Instagram provides
  #
  # @returns String of the ID.
  sig { returns(String) }
  def service_id
    facebook_id
  end
end
