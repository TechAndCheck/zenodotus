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

  desc "output for DallE stuff"
  task dalle_output: :environment do |t, args|
    s3 = Aws::S3::Client.new

    # Create a folder in S3 for the output
    time = Time.now
    bucket_name = "dalle-export-#{time.strftime("%F")}-#{time.strftime("%H-%M")}"

    bucket = Aws::S3::Bucket.new(bucket_name)

    begin
      bucket.create
    rescue Aws::Errors::ServiceError => e
      puts "Couldn't create bucket. Here's why: #{e.message}"
    end

    # Sanity check to make sure the bucket's there
    resp = s3.list_buckets
    raise "Bucket wasn't created??? #{bucket_name}" unless resp.buckets.map(&:name).include? bucket_name


    # Get all media review that's images
    # Go through all the media review
    # output the high res image to the folder
    # save the line to the CSV

    image_archive_items = ArchiveItem.publically_viewable.select { |ai| !ai.images.empty? }
    progress_bar = ProgressBar.create(title: "Media Review Items", total: MediaReview.count)

    # Create a CSV object
    csv_string = CSV.generate do |csv|
      csv << ["id", "media_review.media_url", "media_review.date_published",
              "media_authenticity_category_humanized", 'claim_review.author["name"]',
              "media_review.url"]

      image_archive_items.map do |archive_item|
        # Download and then reupload (yes there's probably better ways to do this. Like a direct S3 copy... but meh)
        media_review = archive_item.media_review
        next if media_review.nil?
        author_name = media_review.claim_reviews.empty? ? "" : media_review.claim_reviews.first.author["name"]

        archive_item.images.each_with_index do |image, index|
          file_name = "#{archive_item.id}-#{index + 1}"
          begin
            image.image.download do |tempfile|
              object = Aws::S3::Object.new(bucket_name, file_name)
              object.upload_file(tempfile.path)
            end
          rescue Shrine::FileNotFound
            # eat it
            next
          end

          csv << [file_name, media_review.media_url,  media_review.date_published,
          media_review.media_authenticity_category_humanized, author_name,
          media_review.url]
        end

        progress_bar.increment
      end
    end

    # Save the CSV
    object_key = "results.csv"
    object = Aws::S3::Object.new(bucket_name, object_key)
    object.put(body: csv_string)

    # Get a link to the folder for ease of access
    begin
      url = bucket.object(object_key).presigned_url(:get)
      puts "Created presigned URL: #{url}"
      # URI(url)
    rescue Aws::Errors::ServiceError => e
      puts "Couldn't create presigned URL for #{bucket.name}:#{object_key}. Here's why: #{e.message}"
    end
  end
end
