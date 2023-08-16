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
      object_key = "exports/fact_check_insights.json"
      bucket = Aws::S3::Bucket.new(Figaro.env.AWS_S3_BUCKET_NAME)
      url = bucket.object(object_key).presigned_url(:put)
      puts "Created presigned URL: #{url}"
      presigned_url = URI(url)
    rescue Aws::Errors::ServiceError => e
      puts "Couldn't create presigned URL for #{bucket.name}:#{object_key}. Here's why: #{e.message}"
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
      rendered_claim_reviews += claim_review.map(&:render_for_export)
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
      rendered_media_reviews += media_review.map(&:render_for_export)
      progressbar.increment
    end

    metadata = {
      "retrievedAt": Time.now,
      "claimReviewCount": rendered_claim_reviews.length,
      "mediaReviewCount": rendered_media_reviews.length
    }
    puts "Rendering JSON"
    output_json = JSON.pretty_generate({ "claimReviews": rendered_claim_reviews, "mediaReviews": rendered_media_reviews, "meta": metadata })

    # Save file and upload to AWS
    temp_json_file = Tempfile.open("temp-json-output")
    begin
      temp_json_file.write(output_json)

      temp_json_file.rewind
      # Upload to AWS
      puts "Uploading to AWS S3"
      response = Net::HTTP.start(presigned_url.host) do |http|
        http.send_request("PUT", presigned_url.request_uri, temp_json_file.read, content_type: "application/json")
      end

      case response
      when Net::HTTPSuccess
        puts "Content uploaded!"
      else
        puts "************************************"
        puts "Error uploading content!"
        puts response.inspect
        puts response.value
        puts "************************************"
      end

      # Set the presigned url to settings
      get_presigned_url = bucket.object(object_key).presigned_url(:get, expires_in: 604800)
      Setting.fact_check_insights_json_url = get_presigned_url

      puts "************************************"
      puts "Success"
      puts "Created presigned url: #{Setting.fact_check_insights_json_url}"
      puts "************************************"
    ensure
      temp_json_file.close
      temp_json_file.unlink
    end
  end
end
