class MediaReviewModels::MediaReview < ApplicationRecord
  belongs_to :archive_item, optional: false, class_name: "ArchiveItem"

  has_one :media_review_item
  has_one :media_review_author

  accepts_nested_attributes_for :media_review_item, :media_review_author
end
