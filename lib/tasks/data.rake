namespace :data do
  desc "load google's feed"
  task load_google_feed: :environment do |t, args|
    if ENV["RAILS_ENV"] == "production" && ENV["HONEYBADGER_API_KEY_GOOGLE_CHECK_IN_ADDRESS"].blank? == false
      # Check in with Honeybadger
      `curl #{ENV["HONEYBADGER_API_KEY_GOOGLE_CHECK_IN_ADDRESS"]} &> /dev/null`
    end

    file_name = "google-feed-#{Time.new.strftime("%Y%m%d-%k:%M:%S")}"
    downloaded_file = File.open file_name, "wb"
    request = Typhoeus::Request.new(
      "https://storage.googleapis.com/datacommons-feeds/factcheck/latest/data.json"
    )

    request.on_headers do |response|
      if response.code != 200
        raise "Request failed"
      end
    end

    request.on_body do |chunk|
      downloaded_file.write(chunk)
    end

    request.on_complete do |response|
      downloaded_file.close
      j = JSON.parse(File.read(file_name))

      last_checked_datetime = DateTime.parse(Setting.google_feed_last_updated)
      puts "Importing claims since #{last_checked_datetime.strftime("%F %T%z")}"

      medias = j["dataFeedElement"]

      media_reviews = []
      claim_reviews = []

      medias.each do |media|
        next if media["item"].nil?

        # Either key may be the time
        compare_time = media.has_key?("dateCreated") ? media["dateCreated"] : media["dateModified"]
        next if DateTime.parse(compare_time) < last_checked_datetime

        # if it's just a single one, put it in the right bucket
        if media["item"].count == 1
          item = media["item"].first
          next if item["itemReviewed"].nil?

          if item["@type"] == "MediaReview" && item["itemReviewed"].has_key?("contentUrl")
            media_reviews << item
          elsif item["@type"] == "ClaimReview"
            claim_reviews << item
          end

          next
        end

        # Otherwise, combine them if it's a MediaReview + ClaimReview
        # We're not sure if the order is always the same, so we'll instead find them ourselves
        media_review_object = nil
        claim_review_object = nil
        media["item"].each do |item|
          next if item["itemReviewed"].nil? # It's a dud

          if item["@type"] == "MediaReview"
            media_review_object = item if item["itemReviewed"].has_key?("contentUrl")
          elsif item["@type"] == "ClaimReview"
            claim_review_object = item
          end
        end

        # First a sanity check
        next if media_review_object.nil? && claim_review_object.nil?

        # Let's make sure we have both types, otherwise push the other one into the buckets
        claim_reviews << claim_review_object if media_review_object.nil?
        media_reviews << media_review_object if claim_review_object.nil?

        next if media_review_object.nil? || claim_review_object.nil?

        # If we have both, let's combine them
        media_review_object["associatedClaimReview"] = claim_review_object
        media_reviews << media_review_object
      end

      puts "Importing #{media_reviews.count} MediaReview objects..."
      if media_reviews.count.positive?
        progress_bar = ProgressBar.create(title: "MediaReview Items", total: media_reviews.count)
        success_count = 0
        media_reviews.each do |media_review_json|
          progress_bar.increment
          ArchiveItem.create_from_media_review(media_review_json, nil)
          success_count += 1
        rescue StandardError => e
          puts "Error archiving"
          puts e.message
          puts "--------------------------------------"
          puts media_review_json
          puts "--------------------------------------"
        end
        puts "Successfully imported #{success_count} MediaReview items"
      end

      puts "Importing #{claim_reviews.count} ClaimReview objects..."
      if claim_reviews.count.positive?
        progress_bar = ProgressBar.create(title: "ClaimReview Items", total: claim_reviews.count)
        success_count = 0
        claim_reviews.each do |claim_review_json|
          progress_bar.increment
          ClaimReview.create_or_update_from_claim_review_hash(claim_review_json, nil, false)
          success_count += 1
        rescue StandardError => e
          puts "Error archiving"
          puts e.message
          puts "--------------------------------------"
          puts claim_review_json
          puts "--------------------------------------"
        end
        puts "Successfully imported #{success_count} ClaimReview items"
      end

      Setting.google_feed_last_updated = j["dateModified"]
      puts "Saving new time as #{Setting.google_feed_last_updated}"
    end

    request.run
  ensure
    downloaded_file.close unless downloaded_file.nil? || downloaded_file.closed?
    File.delete(file_name) if File.exist?(file_name)
  end

  desc "Rescrape MediaReview that isn't populated yet"
  task scrape_orphans: :environment do |t, args|
    orphaned_media_review = MediaReview.where(archive_item_id: nil)
    puts "Found #{orphaned_media_review.count} orphaned MediaReview"

    progress_bar = ProgressBar.create(title: "MediaReview Orphans", total: orphaned_media_review.count)
    orphaned_media_review.each do |media_review|
      media_review.start_scrape
      progress_bar.increment
    end
  end

  desc "Populate Fact Checking Organizations from our Google Sheets"
  task populate_fco: :environment do |t, args|
    if ENV["RAILS_ENV"] == "production" && ENV["HONEYBADGER_API_KEY_GOOGLE_CHECK_IN_ADDRESS"].blank? == false
      # Check in with Honeybadger
      `curl #{ENV["HONEYBADGER_API_KEY_GOOGLE_CHECK_IN_ADDRESS"]} &> /dev/null`
    end

    file_name = "google-feed-#{Time.new.strftime("%Y%m%d-%k:%M:%S")}"
    downloaded_file = File.open file_name, "wb"
    request = Typhoeus::Request.new(
      "https://sheets.googleapis.com/v4/spreadsheets/10nFzJbHbPho7_kMFCRoX7VsQLSNIB3EaUh4ITDlsV0M/values/Fact-checking%20sites?alt=json&key=AIzaSyBgCpWxIarQJSW5AuMxjIRIgLSHeDCcC-U"
    )

    request.on_headers do |response|
      raise "Request failed" if response.code != 200
    end

    request.on_body { |chunk| downloaded_file.write(chunk) }

    request.on_complete do |response|
      downloaded_file.close
      j = JSON.parse(File.read(file_name))

      # This is a weird thing where it's a JSON doc that's sorta like a CSV
      # It's an array of arrays, but the first array is the headers

      # Get the headers
      headers = j["values"].first
      headers = headers.map { |h| h.squish.downcase.tr(" ", "_").gsub(/[^[\w]]/, "") }

      # Go through all the rows
      organizations = j["values"][1..].map do |row|
        # Create a hash of the row
        row_hash = {}
        row.each_with_index { |value, index| row_hash[headers[index]] = value }
        row_hash
      end

      puts "Importing #{organizations.count} Fact Checking Organizations..."

      organizations.each do |organization|
        next if FactCheckOrganization.exists?(url: organization["url"].squish)
        FactCheckOrganization.create!({ name: organization["name"].squish, url: organization["url"].squish })
      rescue URI::InvalidURIError
        # eat this
      end
    end

    request.run
  end

  #   desc "load sample data"
  #   task load_samples: :environment do |t, args|
  #     number_of_lines = `wc -l test_urls.txt`.to_i

  #     progressbar = ProgressBar.create(title: "Loading Sample Data", total: number_of_lines)
  #     File.readlines("test_urls.txt").each do |url|
  #       url = url.strip!
  #       next if url.blank?
  #       # This is copied straight from ApplicationController, if that becomes a problem we'll refactor
  #       # later

  #       # Load all models so we can inspect them
  #       Zeitwerk::Loader.eager_load_all

  #       # Get all models conforming to ApplicationRecord, and then check if they implement the magic
  #       # function.
  #       models = ApplicationRecord.descendants.select do |model|
  #         if model.respond_to? :can_handle_url?
  #           model.can_handle_url?(url)
  #         end
  #       end

  #       # We'll always choose the first one
  #       model = models.first
  #       model.create_from_url(url)

  #       progressbar.increment
  #     end
  #   end
end
