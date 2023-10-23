namespace :claim_review do
  desc "Fix fistAppearance issue"
  task fix_first_appearance: :environment do |t, args|
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
    rescue StandardError
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

  desc "swap fistAppearance issue to appearance"
  task array_fix: :environment do |t, args|
    post = ClaimReview.where("author->>'name' = 'Washington Post'")
    factcheckorg = ClaimReview.where("author->>'name' = 'FactCheck.org'")
    politifact = ClaimReview.where("author->>'name' = 'PolitiFact'")
    gazette = ClaimReview.where("author->>'name' = 'Cedar Rapids Gazette'")
    cnn = ClaimReview.where("author->>'name' = 'CNN'")

    partners_claim_reviews = [post, factcheckorg, politifact, gazette, cnn].flatten
    count = 0
    partners_claim_reviews.each do |cr|
      if cr.item_reviewed["appearance"].is_a?(Hash)
        count += 1
        cr.item_reviewed["appearance"] = [cr.item_reviewed["appearance"]]
        cr.save!
      end
    end
    puts "Did #{count}"
  end

  desc "deduplicate"
  task dedup: :environment do |t, args|

    crs  = ClaimReview.find_by_sql("SELECT * FROM claim_reviews WHERE claim_reviewed IN (SELECT claim_reviewed FROM claim_reviews GROUP BY claim_reviewed HAVING COUNT(*) > 1) ORDER BY url, created_at ASC").group_by do |cr|
      "#{cr.url} :: #{cr.claim_reviewed}"
    end

    progress_bar = ProgressBar.create(title: "MediaReview Items", total: crs.keys.count)

    crs.keys.each do |key|
      progress_bar.increment
      duplicates = cr[key]
      # If we have duplicates, loop them
      if duplicates.count > 1
        # Go through and find all the ClaimReview that have a MediaReview on them
        archived_duplicates_with_media_review = duplicates.find_all do |duplicate|
          !duplicate.media_review.nil?
        end

        # Go through and find all that have a MediaReview that has also been archived, because
        # that one we really want to keep
        archived_duplicates_with_media_review_and_archived = archived_duplicates_with_media_review.find_all do |duplicate|
          duplicate.media_review.archive_item != nil
        end

        # If there are archived duplicates, we remove the first one to save and delete the rest
        # (they'll be sorted already)
        if archived_duplicates_with_media_review.empty?
          duplicates.shift
        elsif archived_duplicates_with_media_review_and_archived.empty?
          duplicates.delete(archived_duplicates_with_media_review.first)
        else
          duplicates.delete(archived_duplicates_with_media_review_and_archived.first)
        end

        duplicates.each(&:destroy)
      end
    end
  end
end
