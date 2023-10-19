namespace :media_review do
  desc "deduplicate"
  task dedup: :environment do |t, args|
    progress_bar = ProgressBar.create(title: "MediaReview Items", total: MediaReview.count)

    MediaReview.all.order(:created_at).map do |mr|
      progress_bar.increment
      duplicates = mr.find_duplicates
      # If we have duplicates, loop them
      if mr.find_duplicates.count.positive?
        # Since we may want to delete the current MediaReview (say a later one was archived, but this
        # one wasn't) we add it to the list
        duplicates.prepend mr

        # Go through and find all the MediaReview that have been archived
        archived_duplicates = duplicates.find_all do |duplicate|
          !duplicate.archive_item.nil?
        end

        # If there are archived duplicates, we remove the first one to save and delete the rest
        # (they'll be sorted already)
        if archived_duplicates.empty?
          duplicates.shift
        else
          duplicates.delete(archived_duplicates.first)
        end

        duplicates.each(&:destroy)
      end
    end
  end
end
