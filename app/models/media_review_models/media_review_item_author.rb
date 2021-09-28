# typed: false

class MediaReviewModels::MediaReviewItemAuthor < ApplicationRecord
  belongs_to :media_review_item, optional: false, class_name: "MediaReviewModels::MediaReviewItem"

end
