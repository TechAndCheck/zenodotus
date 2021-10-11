# typed: false

class MediaReviewModels::MediaReviewItem < ApplicationRecord
  belongs_to :media_review, optional: false, class_name: "MediaReviewModels::MediaReview"

  has_one :media_review_item_author, dependent: :destroy
  has_many :media_item_appearance, dependent: :destroy

  accepts_nested_attributes_for :media_review_item_author, :media_item_appearance
end
