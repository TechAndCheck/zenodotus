namespace :claim_review_author_fix do
  desc "Fix authors"
  task fix: :environment do |t, args|
    ClaimReview.all.each do |claim_review|
      claim_review.claim_review_author = ClaimReviewAuthor.find_or_create_by(url: claim_review.author["url"],
                                                                             name: claim_review.author["name"])
      claim_review.save!
    end
  end
end
