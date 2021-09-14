# typed:false

class ArchiveItem < ApplicationRecord
  delegated_type :archivable_item, types: %w[ Sources::Tweet Sources::InstagramPost ]
  delegate :service_id, to: :archivable_item
  delegate :images, to: :archivable_item
  delegate :videos, to: :archivable_item
  # delegate :media_review, to: :archivable_item

  has_one :media_review, dependent: :destroy, foreign_key: :archive_item_id
  # Creates an +ArchiveEntity
  #
  # @!scope class
  # @params media_review Hash a hash of json media_review
  # @return an ArchiveItem created from the media_review
  def self.create_from_media_review(media_review)
    appearance = media_review["itemReviewed"]["mediaItemAppearance"].select do |appearance|
      appearance.keys.include? "contentUrl"
    end.first

    url = appearance["contentUrl"]

    object_model = model_for_url(url)
    object = object_model.create_from_url(url)

    # This results in two database saves per creation, which isn't great.
    # However, we'll refactor another time after it works
    object.update!({ media_review: media_review })
    object
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
end
