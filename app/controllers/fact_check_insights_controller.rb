# typed: strict

class FactCheckInsightsController < ApplicationController
  # We don't route to this URL directly.
  # Instead, `application#index` renders its template without a redirect.
  sig { void }
  def index; end

  sig { void }
  def download
    # render json: {
    #         error: "Downloads are currently disabled."
    #       }, status: :unauthorized

    respond_to do |format|
      format.html do; end
      format.json do
        unless user_signed_in? && current_user.can_access_fact_check_insights?
          render json: {
            error: "You do not have permission to view that resource."
          }, status: :unauthorized
          return
        end
        send_data(FactCheckInsightsController.generate_json, type: "application/json", filename: "fact_check_insights.json")
      end

      format.zip do
        unless user_signed_in? && current_user.can_access_fact_check_insights?
          render json: {
            error: "You do not have permission to view that resource."
          }, status: :unauthorized
          return
        end
        send_data(FactCheckInsightsController.generate_csv_zip, type: "application/zip", filename: "fact_check_insights.zip")
      end
    end
  end

  sig { void }
  def guide; end

  sig { void }
  def highlights; end

  sig { void }
  def optout; end

private

  # Generate a JSON-formatted string of ClaimReview and MediaReview data
  sig { returns(String) }
  def self.generate_json
    all_claim_reviews = ClaimReview.all.map { |claim_review| JSON.parse(claim_review.render_for_export) }
    all_media_reviews = MediaReview.all.map { |media_review| JSON.parse(media_review.render_for_export) }
    metadata = {
      "retrievedAt": Time.now,
      "claimReviewCount": all_claim_reviews.length,
      "mediaReviewCount": all_media_reviews.length
    }

    JSON.pretty_generate({ "claimReviews": all_claim_reviews, "mediaReviews": all_media_reviews, "meta": metadata })
  end

  # Generate a CSV-formatted string of ClaimReview and MediaReview data
  sig { returns(String) }
  def self.generate_csv_zip
    all_claim_reviews = ClaimReview.all.map { |claim_review| JSON.parse(claim_review.render_for_export) }
    all_media_reviews = MediaReview.all.map { |media_review| JSON.parse(media_review.render_for_export) }

    compressed_filestream = Zip::OutputStream.write_buffer(::StringIO.new("")) do |zos|
      zos.put_next_entry "claim_reviews.csv"
      claim_review_csv = Decombobulate.new(all_claim_reviews).to_csv
      zos.print claim_review_csv

      zos.put_next_entry "media_reviews.csv"
      media_review_csv = Decombobulate.new(all_media_reviews).to_csv
      zos.print media_review_csv
    end

    compressed_filestream.rewind
    compressed_filestream.read
  end
end
