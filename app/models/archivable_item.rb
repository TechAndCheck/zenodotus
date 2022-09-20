# typed: true

module ArchivableItem
  extend ActiveSupport::Concern

  delegate :url_helpers, to: "Rails.application.routes"

  included do
    has_one :archive_item, as: :archivable_item, touch: true, dependent: :destroy
  end

  # This method should be overriden by any class that uses this module, returning an object
  # composed of the following attributes that will be used in templates that show normalized
  # representations of archivable items.
  #
  # {
  #   publishing_platform_shortname:    "",
  #   publishing_platform_display_name: "",
  #   author_canonical_path:            "",
  #   author_profile_image_url:         "",
  #   author_display_name:              "",
  #   author_username:                  "",
  #   author_community_count:           0,
  #   author_community_noun:            "",
  #   archive_item_media:               self,
  #   archive_item_caption:             "",
  #   published_at:                     "",
  # }
  #
  # See any existing archivable item class for a representative example.
  def normalized_attrs_for_views
    raise "Please implement a `normalized_attrs_for_views` method"
  end

  # Syntactic sugar for safely determining whether this item actually has any images or videos.
  #
  # @return Boolean
  def has_displayable_media?
    self.try(:images).try(:empty?) == false || self.try(:videos).try(:empty?) == false
  end

  # Combines images and videos into a single array.
  #
  # This is because an archivable item may be a mixed-image/video collection and we need to be able
  # to represent it.
  #
  # NB: Currently this sorts by creation date. This is a coarse proxy for the actual display order,
  #     and a future improvement should scrape and use true display order.
  #
  # @return Array of MediaModels.
  def combined_media
    ((self.try(:images) || []) + (self.try(:videos) || [])).sort_by(&:created_at)
  end
end
