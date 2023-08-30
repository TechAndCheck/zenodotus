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
    fixed = 0
    appearance_nil = 0
    both_nil = 0
    errors = 0
    partners_claim_reviews.each_with_index do |claim_review, index|
      if claim_review.item_reviewed["appearance"].nil? || claim_review.item_reviewed["appearance"].empty?
        appearance_nil += 1
        next
      end

      unless claim_review.item_reviewed["appearance"].first.is_a?(Hash)
        claim_review.item_reviewed["appearance"] = claim_review.item_reviewed["appearance"].map do |appearance|
          {
            "@type": "CreativeWork",
            "url": appearance,
          }
        end
        claim_review.save!
        fixed += 1
      end

      if claim_review.item_reviewed.dig("firstAppearance", "url").nil? && claim_review.item_reviewed["appearance"]&.first&.dig("url").nil?
        both_nil += 1
        next
      end

      if claim_review.item_reviewed.dig("firstAppearance", "url") == claim_review.item_reviewed["appearance"]&.first&.dig("url")
        claim_review.item_reviewed["firstAppearance"] = nil
        claim_review.save!
        count += 1
      end
    rescue StandardError => e
      errors += 1
    end

    puts "Skipped #{appearance_nil} ClaimReviews with nil appearances"
    puts "Skipped #{both_nil} ClaimReviews with nil firstAppearance and nil appearances"
    puts "#{fixed} needed Fixing"
    puts "Skipped #{errors} ClaimReviews with errors"
    puts "Fixed #{count} ClaimReviews"
  end

  desc "swap fistAppearance issue to appearance"
  task swap: :environment do |t, args|
    post = ClaimReview.where("author->>'name' = 'Washington Post'")
    factcheckorg = ClaimReview.where("author->>'name' = 'FactCheck.org'")
    politifact = ClaimReview.where("author->>'name' = 'PolitiFact'")
    gazette = ClaimReview.where("author->>'name' = 'Cedar Rapids Gazette'")
    cnn = ClaimReview.where("author->>'name' = 'CNN'")

    partners_claim_reviews = [post, factcheckorg, politifact, gazette, cnn].flatten
    filtered = partners_claim_reviews.filter do |cr|
      cr.item_reviewed["firstAppearance"].nil? == false && (cr.item_reviewed["appearance"].nil? || cr.item_reviewed["appearance"].empty?)
    end

    count = 0
    filtered.each do |cr|
      if cr.author["image"].include?("factstream")
        count += 1
        cr.item_reviewed["appearance"] = cr.item_reviewed["firstAppearance"]
        cr.item_reviewed["firstAppearance"] = nil
        cr.save!
      end
    end
    puts "Did #{count}"
  end
end
