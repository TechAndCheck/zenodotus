namespace :fact_check_organization_fix do
  desc "Fix authors"
  task fix: :environment do |t, args|
    progress_bar = ProgressBar.create(title: "ClaimReview Items", total: ClaimReview.count, format: "%E %B %c/%C %p%% %t")

    ClaimReview.unscoped.all.each do |claim_review|
      progress_bar.increment
      next if claim_review.claim_review_author.present?

      fact_check_organization = claim_review.fact_check_organization_for_author_from_url(claim_review.author["url"])
      next if fact_check_organization.nil?

      begin
        Rails.logger.info "Updating claim review #{claim_review.id} with org #{fact_check_organization.name}: #{fact_check_organization.id}"
        claim_review.update!(claim_review_author: fact_check_organization)
      rescue StandardError => e
        Rails.logger.info("Error saving claim review #{claim_review.id} - #{e.inspect}")
      end

      Rails.logger.info "Error saving org #{host})" unless claim_review.valid?
    end

    progress_bar = ProgressBar.create(title: "MediaReview Items", total: MediaReview.count, format: "%E %B %c/%C %p%% %t")

    MediaReview.all.each do |media_review|
      progress_bar.increment
      host = URI.parse(media_review.url).host
      fact_check_organization = FactCheckOrganization.where(host_name: host).order(name: :asc)&.first
      next if fact_check_organization.nil?

      media_review.update(media_review_author: fact_check_organization)
      Rails.logger.info "Error saving org #{host})" unless  media_review.valid?
    end
  end
end
