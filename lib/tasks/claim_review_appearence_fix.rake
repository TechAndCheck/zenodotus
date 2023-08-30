namespace :claim_review_appearance_fix do
  desc "Fix fistAppearance issue"
  task fix: :environment do |t, args|
    post = ClaimReview.where("author->>'name' = 'Washington Post'")
    factcheckorg = ClaimReview.where("author->>'name' = 'FactCheck.org'")
    politifact = ClaimReview.where("author->>'name' = 'PolitiFact'")
    gazette = ClaimReview.where("author->>'name' = 'Cedar Rapids Gazette'")
    cnn = ClaimReview.where("author->>'name' = 'CNN'")

    partners_claim_reviews = [post, factcheckorg, politifact, gazette, cnn].flatten

    count = 0
    appearance_nil = 0
    both_nil = 0
    partners_claim_reviews.each_with_index do |claim_review, index|
      if claim_review.item_reviewed["appearance"].nil?
        appearance_nil += 1
        next
      end

      if claim_review.item_reviewed.dig("firstAppearance", "url").nil? && claim_review.item_reviewed["appearance"]&.first&.dig("url").nil?
        both_nil += 1
        next
      end

      if claim_review.item_reviewed.dig("firstAppearance", "url") == claim_review.item_reviewed["appearance"]&.first&.dig("url")
        claim_review.item_reviewed["firstAppearance"] = nil
        # claim_review.save!
        count += 1
      end
    rescue StandardError => e
      debugger
    end

    puts "Skipped #{appearance_nil} ClaimReviews with nil appearances"
    puts "Skipped #{both_nil} ClaimReviews with nil firstAppearance and nil appearances"
    puts "Fixed #{count} ClaimReviews"

  end
end
