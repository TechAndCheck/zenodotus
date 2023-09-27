namespace :fact_check_organization_fix do
  desc "Fix authors"
  task fix: :environment do |t, args|
    ClaimReview.all.each do |claim_review|
      host = URI.parse(claim_review.url).host
      fact_check_organization = FactCheckOrganization.find_by(host_name: host)
      next if fact_check_organization.nil?

      claim_review.update!(claim_review_author: fact_check_organization)
    end

    MediaReview.all.each do |media_review|
      host = URI.parse(media_review.url).host
      fact_check_organization = FactCheckOrganization.find_by(host_name: host)
      next if fact_check_organization.nil?

      media_review.update!(media_review_author: fact_check_organization)
    end
  end
end
