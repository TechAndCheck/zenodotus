namespace :vault do
  desc "Check for and resubmit missing media for processing"
  task :check_and_resubmit, [:start_date] => [:environment] do |t, args|
    date = args[:start_date]
    # Parse the date to make sure it's real
    if date.present?
      begin
        date = Date.parse(date)
      rescue Date::Error
        puts "Invalid date format. Please use YYYY-MM-DD"
        return
      end
    end

    # If a date is provided, only check items created after that date
    # Otherwise, check all items
    items = date.present? ? ArchiveItem.where("created_at >= ?", date) : ArchiveItem.all

    items.map do |item|
      if item.images.empty? && item.videos.empty? && item.scrape.present? && item.scrape.fulfilled
        puts "Resubmitting #{item.id} for processing"
        item.scrape.enqueue
      end
    end
  end
end
