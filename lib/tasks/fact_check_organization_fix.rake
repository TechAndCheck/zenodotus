namespace :fact_check_organization_fix do
  desc "Fix authors"
  task fix: :environment do |t, args|
    progress_bar = ProgressBar.create(title: "ClaimReview Items", total: ClaimReview.count, format: "%E %B %c/%C %p%% %t")

    ClaimReview.all.each do |claim_review|
      progress_bar.increment
      host = URI.parse(claim_review.url).host
      fact_check_organization = FactCheckOrganization.where(host_name: host).order(name: :asc)&.first
      next if fact_check_organization.nil?

      claim_review.update(claim_review_author: fact_check_organization)
      puts "Error saving org #{host})" unless claim_review.valid?
    end

    progress_bar = ProgressBar.create(title: "MediaReview Items", total: MediaReview.count, format: "%E %B %c/%C %p%% %t")

    MediaReview.all.each do |media_review|
      progress_bar.increment
      host = URI.parse(media_review.url).host
      fact_check_organization = FactCheckOrganization.find_by(host_name: host)
      next if fact_check_organization.nil?

      media_review.update(media_review_author: fact_check_organization)
      puts "Error saving org #{host})" unless  media_review.valid?
    end
  end
end
