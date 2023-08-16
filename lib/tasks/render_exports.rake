namespace :render_exports do
  GROUP_SIZE = 4000

  desc "Render JSON and CSV exports and upload to AWS"
  task render_and_upload: :environment do |t, args|
    if ENV["RAILS_ENV"] == "production" && ENV["HONEYBADGER_API_KEY_CSV_JSON_GENERATION_ADDRESS"].blank? == false
      # Check in with Honeybadger
      `curl #{ENV["HONEYBADGER_API_KEY_CSV_JSON_GENERATION_ADDRESS"]} &> /dev/null`
    end

    # Render JSON
    rendered_claim_reviews = []
    claim_review_count = ClaimReview.count
    claim_review_chunk_size = (claim_review_count / GROUP_SIZE).to_i
    claim_review_chunk_size += 1 if (claim_review_count % GROUP_SIZE).positive?

    progressbar = ProgressBar.create(title: "ClaimReview", total: claim_review_chunk_size, format: "%t | %b | %a/%f | eta: %l | %P%% | %c/%C")

    all_claim_reviews = ClaimReview.all.each_slice(GROUP_SIZE) do |claim_review|
      rendered_claim_reviews += claim_review.map(&:render_for_export)
      progressbar.increment
    end

    rendered_media_reviews = []
    media_review_count = MediaReview.count
    media_review_chunk_size = media_review_count / GROUP_SIZE
    media_review_chunk_size += 1 if (media_review_count % GROUP_SIZE).positive?

    progressbar = ProgressBar.create(title: "MediaReview", total: media_review_chunk_size, format: "%t | %b | %a/%f | eta: %l | %P%% | %c/%C")

    all_media_reviews = MediaReview.all.each_slice(GROUP_SIZE) do |media_review|
      rendered_media_reviews += media_review.map(&:render_for_export)
      progressbar.increment
    end

    metadata = {
      "retrievedAt": Time.now,
      "claimReviewCount": all_claim_reviews.length,
      "mediaReviewCount": all_media_reviews.length
    }
    puts "Rendering JSON"
    output_json = JSON.pretty_generate({ "claimReviews": all_claim_reviews, "mediaReviews": all_media_reviews, "meta": metadata })

    # Save file and upload to AWS
    temp_json_file = Tempfile.open("temp-json-output")
    begin
      temp_json_file.write(output_json)

      # Zip file
      Zip::File.open("fact_check_insights.zip", Zip::File::CREATE) do |zipfile|
        zipfile.add("fact_check_insights.json", "fact_check_insights.json")
      end

      debugger
      # Upload to AWS
      # s3 = Aws::S3::Resource.new(region: ENV["AWS_REGION"])
      # obj = s3.bucket(ENV["AWS_S3_BUCKET"]).object("exports/fact_check_insights.zip")
      # obj.upload_file("fact_check_insights.zip")
    ensure
      temp_json_file.close
    end
  end
end
