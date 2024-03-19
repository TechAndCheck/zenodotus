# typed: strict

class ArchiveItem < ApplicationRecord
  include Dhashable

  delegated_type :archivable_item, types: %w[Sources::Tweet Sources::InstagramPost Sources::FacebookPost Sources::YoutubePost Sources::TikTokPost]
  delegate :service_id, to: :archivable_item
  delegate :images, to: :archivable_item
  delegate :videos, to: :archivable_item
  # delegate :posted_at, to: :archivable_item

  has_one :media_review, dependent: :nullify, foreign_key: :archive_item_id
  has_one :screenshot, dependent: :destroy, foreign_key: :archive_item_id, class_name: "Screenshot"
  accepts_nested_attributes_for :screenshot, allow_destroy: true
  has_many :image_hashes, dependent: :destroy # since videos are searched using images. this is fine
  belongs_to :submitter, optional: true, class_name: "User"
  belongs_to :scrape, optional: true

  has_many :archive_items_users, dependent: :destroy, class_name: "ArchiveItemUser"
  has_many :users, through: :archive_items_users

  before_create :update_posted, :set_private_flag

  # Yes, default scopes are usually a code smell, but the *vast* majority of the time we don't want to include
  # private archive items in our queries. We'll be explicit otherwise.
  scope :publically_viewable, -> { where(private: false) }

  def update_posted
    self.posted_at = self.archivable_item.posted_at
  end

  def set_private_flag
    self.private = self.submitter.present?
  end

  def promote_to_public
    self.update(private: false)
  end

  # Begins the Scrape process that will allow us to create an ArchiveItem
  #
  # @!scope class
  # @params media_review [Hash] A MediaReview JSON object
  # @return A MediaReview object that we'll attach to the soon-to-be-scraped ArchiveItem during Scrape fulfillment
  def self.create_from_media_review(media_review, external_unique_id)
    # We want to make sure that we have an actual link to archive first just in case
    url = nil
    logger.info "Starting to create media review"

    if media_review["itemReviewed"].has_key?("contentUrl")
      url = media_review["itemReviewed"]["contentUrl"]
    elsif media_review["itemReviewed"].has_key?("mediaItemAppearance")
      media_review["itemReviewed"]["mediaItemAppearance"].each do |media_item_appearance|
        if media_item_appearance.has_key?("accessedOnUrl")
          url = media_item_appearance["accessedOnUrl"]
          break
        end
      end

      media_review["itemReviewed"]["contentUrl"] = url unless url.nil?
    end

    raise "No url found to archive" if url.nil?

    # For the moment we create an "orphan" MediaReview without a parent ArchiveItem
    # The ArchiveItem will be created after Zenodotus receives a callback from Hypatia
    # That callback will trigger the Scrape fulfillment process which
    # which will attach this MediaReview to the ArchiveItem

    media_review_object = MediaReview.create_or_update_from_media_review_hash(media_review, external_unique_id, false)
    logger.info "Created media review object with id #{media_review_object}"
    media_review_object.start_scrape

    media_review_object
  end

  # Returns an array of ArchiveItems modified for JSON export
  # @params relation T.Array[ArchiveItem] a set of ArchiveItems to be exported
  # @return a stringified representation of ArchiveItems for export
  sig { params(relation: T.nilable(T::Array[ArchiveItem])).returns(String) }
  def self.generate_json_for_export(relation = nil)
    media_reviews = relation.map { |item| item.media_review }
    MediaReviewBlueprint.render_as_json(media_reviews).to_json
  end

  # Return a class that can handle a given +url+
  sig { params(url: String).returns(T.nilable(Class)) }
  def self.model_for_url(url)
    # Load all models so we can inspect them
    Zeitwerk::Loader.eager_load_all

    # Get all models conforming to ApplicationRecord, and then check if they implement the magic
    # function.
    models = ApplicationRecord.descendants.select do |model|
      if model.respond_to? :can_handle_url?
        model.can_handle_url?(url)
      end
    end

    # We'll always choose the first one
    models.first
  end

  # Note: You may want to use `alias` or `alias_method` here instead of the following functions
  # it *does not* work. Probably because of the `delegated_type` metaprogramming, but hacking that
  # is a bad idea.

  # A helper function to make it easier to access the item, instead of `.sources_tweet`
  # this allows just the use of `.tweet`
  #
  # @returns +Sources::Tweet+
  sig { returns(T.nilable(Sources::Tweet)) }
  def tweet
    self.sources_tweet
  end

  # A helper function to make it easier to access the item, instead of `.sources_instagram_post`
  # this allows just the use of `.instagram_post`
  #
  # @returns +Sources::InstagramPost+
  sig { returns(T.nilable(Sources::InstagramPost)) }
  def instagram_post
    self.sources_instagram_post
  end

  # A helper function to make it easier to access the item, instead of `.sources_facebook_post`
  # this allows just the use of `.facebook_post`
  #
  # @returns +Sources::FacebookPost+
  sig { returns(T.nilable(Sources::FacebookPost)) }
  def facebook_post
    self.sources_facebook_post
  end

  # A helper function to make it easier to access the item, instead of `.sources_youtube_post`
  # this allows just the use of `.youtube_post`
  #
  # @returns +Sources::YoutubePost+
  sig { returns(T.nilable(Sources::YoutubePost)) }
  def youtube_post
    self.sources_youtube_post
  end

  # A helper function to make it easier to access the item, instead of `.sources_tik_tok_post`
  # this allows just the use of `.tik_tok_post`
  #
  # @returns +Sources::TikTokPost+
  sig { returns(T.nilable(Sources::TikTokPost)) }
  def tik_tok_post
    self.sources_tik_tok_post
  end

  # Proxy for the normalized representation of this related archivable item for use in the view
  # template, decorated with additional attributes.
  #
  # @returns Hash of normalized attributes.
  sig { returns(Hash) }
  def normalized_attrs_for_views
    {
      **self.archivable_item.normalized_attrs_for_views,
      archived_at: self.created_at
    }
  end
end
