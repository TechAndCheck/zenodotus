namespace :claim_review_appearance_fix do
  desc "Fix fistAppearance issue"
  task fix: :environment do |t, args|
    post = ClaimReview.where("author->>'name' = 'Washington Post'")
    factcheckorg = ClaimReview.where("author->>'name' = 'FactCheck.org'")
    politifact = ClaimReview.where("author->>'name' = 'PolitiFact'")
    gazette = ClaimReview.where("author->>'name' = 'Cedar Rapids Gazette'")
    cnn = ClaimReview.where("author->>'name' = 'CNN'")

    partners_claim_reviews = [post, factcheckorg, politifact, gazette, cnn]

    count = 0
    partners_claim_reviews.each do |claim_review|
      next if claim_review.item_reviewed["appearance"].nil?
      next if claim_review.item_reviewed.dig("firstAppearance", "url").nil? && claim_review.item_reviewed["appearance"]&.first&.dig("url").nil?
      if claim_review.item_reviewed.dig("firstAppearance", "url") == claim_review.item_reviewed["appearance"]&.first&.dig("url")
        claim_review.item_reviewed["firstAppearance"] = nil
        # claim_review.save!
        count += 1
      end
    end

    puts "Fixed #{count} ClaimReviews"
  end
end
