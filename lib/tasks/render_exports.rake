namespace :render_exports do
  GROUP_SIZE = 4000

  desc "Render JSON and CSV exports and upload to AWS"
  task render_and_upload: :environment do |t, args|
    if ENV["RAILS_ENV"] == "production" && ENV["HONEYBADGER_API_KEY_CSV_JSON_GENERATION_ADDRESS"].blank? == false
      # Check in with Honeybadger
      `curl #{ENV["HONEYBADGER_API_KEY_CSV_JSON_GENERATION_ADDRESS"]} &> /dev/null`
    end

    # First we set up a presigned AWS url so that if we can't access it we don't waste all the time
    begin
      json_object_key = "exports/fact_check_insights.json"
      bucket = Aws::S3::Bucket.new(Figaro.env.AWS_S3_BUCKET_NAME)
      json_url = bucket.object(json_object_key).presigned_url(:put)
      json_presigned_url = URI(json_url)

      csv_object_key = "exports/fact_check_insights.zip"
      csv_url = bucket.object(csv_object_key).presigned_url(:put)
      csv_presigned_url = URI(csv_url)
    rescue Aws::Errors::ServiceError => e
      puts "Couldn't create presigned URL for #{bucket.name}:#{json_url} . Here's why: #{e.message}"
    end

    # Render JSON
    rendered_claim_reviews = []
    claim_review_count = ClaimReview.count
    claim_review_chunk_size = (claim_review_count / GROUP_SIZE).to_i
    claim_review_chunk_size += 1 if (claim_review_count % GROUP_SIZE).positive?

    progressbar = ProgressBar.create(
      title: "ClaimReview",
      total: claim_review_chunk_size,
      format: "%t | %b | %a/%f | eta: %l | %P%% | %c/%C"
    )

    ClaimReview.all.each_slice(GROUP_SIZE) do |claim_review|
      rendered_claim_reviews += claim_review.map(&:render_to_csv_line)
      progressbar.increment
    end

    rendered_media_reviews = []
    media_review_count = MediaReview.count
    media_review_chunk_size = media_review_count / GROUP_SIZE
    media_review_chunk_size += 1 if (media_review_count % GROUP_SIZE).positive?

    progressbar = ProgressBar.create(
      title: "MediaReview",
      total: media_review_chunk_size,
      format: "%t | %b | %a/%f | eta: %l | %P%% | %c/%C"
    )

    MediaReview.all.each_slice(GROUP_SIZE) do |media_review|
      rendered_media_reviews += media_review.map(&:render_to_csv_line)
      progressbar.increment
    end

    metadata = {
      "retrievedAt": Time.now,
      "claimReviewCount": rendered_claim_reviews.length,
      "mediaReviewCount": rendered_media_reviews.length
    }
    puts "Rendering JSON"

    begin
      output_json = JSON.pretty_generate({ "claimReviews": rendered_claim_reviews, "mediaReviews": rendered_media_reviews, "meta": metadata })
      puts "Rendered JSON successfully"
    rescue StandardError => e
      puts "Error rendering JSON: #{e.message}"
      raise e
    end

    puts "Rendering ClaimReview CSV"
    # Render ClaimReview CSV
    claim_review_csv = CSV.generate(encoding: "UTF-8") do |csv|
      csv << ClaimReview.csv_headers
      rendered_claim_reviews.each do |claim_review|
        csv << claim_review
      end
    end

    puts "Rendering MediaReview CSV"
    # Render MediaReview CSV
    media_review_csv = CSV.generate(encoding: "UTF-8") do |csv|
      csv << MediaReview.csv_headers
      rendered_media_reviews.each do |media_review|
        csv << media_review
      end
    end

    # Excel doesn't like to assume files are UTF8 (unlike everyone else for the last 20 years)
    # so we have to add a byte string to the start of the files.
    claim_review_csv.prepend("\uFEFF")
    media_review_csv.prepend("\uFEFF")

    zipfile_name = "tmp/fact_check_insights.zip"

    Zip::File.open(zipfile_name, create: true) do |zipfile|
      zipfile.get_output_stream("claim_review.csv") { |f| f.write claim_review_csv }
      zipfile.get_output_stream("media_review.csv") { |f| f.write media_review_csv }
    end

    begin
      # Upload to AWS
      puts "Uploading JSON to AWS S3"
      response = Net::HTTP.start(json_presigned_url.host) do |http|
        http.send_request("PUT", json_presigned_url.request_uri, output_json, content_type: "application/json")
      end

      case response
      when Net::HTTPSuccess
        puts "JSON Content uploaded!"
      else
        puts "************************************"
        puts "Error uploading JSON content!"
        puts response.inspect
        puts response.value
        puts "************************************"
      end

      puts "Uploading CSV to AWS S3"
      response = Net::HTTP.start(csv_presigned_url.host) do |http|
        http.send_request("PUT", csv_presigned_url.request_uri, File.read(zipfile_name), content_type: "application/zip")
      end

      case response
      when Net::HTTPSuccess
        puts "CSV Content uploaded!"
      else
        puts "************************************"
        puts "Error uploading CSV content!"
        puts response.inspect
        puts response.value
        puts "************************************"
      end

      puts "************************************"
      puts "Success"
      puts "************************************"
    rescue StandardError => e
      puts "************************************"
      puts "Error uploading content!"
      puts e.message
      raise e
      puts "************************************"
    end
  ensure
    File.delete(zipfile_name) if !zipfile_name.nil? && File.exist?(zipfile_name)
  end
end
