# typed: false

class MediaReviewModels::MediaItemAppearance < ApplicationRecord
  belongs_to :media_review_item, optional: false, class_name: "MediaReviewModels::MediaReviewItem"
end
