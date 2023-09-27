namespace :fact_check_organization_fix do
  desc "Fix authors"
  task fix: :environment do |t, args|
    ClaimReview.all.each do |claim_review|
      fact_check_organization = FactCheckOrganization.find_by(url: claim_review.author["url"])
      next if fact_check_organization.nil?

      claim_review.update!(claim_review_author: fact_check_organization)
    end
  end
end
