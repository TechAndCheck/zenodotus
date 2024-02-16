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

  desc "Even out the posted_at dates"
  task fill_posted_at: :environment do |t, args|
    progress_bar = ProgressBar.create(title: "Archive Items", total: ArchiveItem.count)

    ArchiveItem.all.order(:created_at).map do |ai|
      progress_bar.increment
      ai.posted_at = ai.archivable_item.posted_at
      ai.save(validate: false)
    rescue Aws::S3::Errors::NoSuchKey
      puts "No AWS key for #{ai.id}"
    end
  end
end
