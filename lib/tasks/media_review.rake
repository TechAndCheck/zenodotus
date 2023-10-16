namespace :media_review do
  desc "deduplicate"
  task dedup: :environment do |t, args|
    MediaReview.all.each do |mr|
      mr.destroy if mr.find_duplicates.count > 1
    end
  end
end
