# typed: false

class MediaReviewModels::MediaReviewAuthor < ApplicationRecord
  belongs_to :media_review, optional: false, class_name: "MediaReviewModels::MediaReview"
end
