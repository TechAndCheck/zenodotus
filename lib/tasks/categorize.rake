namespace :categorize do
  desc "Categorize ArchiveItems"
  task archive_items: :environment do |t, args|
    progress_bar = ProgressBar.create(title: "Archive Items", total: ArchiveItem.count, format: "%E %B %c/%C %p%% %t")

    ArchiveItem.find_each do |archive_item|
      progress_bar.increment
      begin
        archive_item.categorize!
        progress_bar.log("Categorized archive item #{archive_item.id} as #{archive_item.categories.pluck("name").join(", ")}.")
      rescue StandardError => e
        progress_bar.log("Error categorizing archive item #{archive_item.id} - #{e.inspect}")
        next
      end
    end
  end
end
