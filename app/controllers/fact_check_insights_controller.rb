# typed: strict

class FactCheckInsightsController < ApplicationController
  # We don't route to this URL directly.
  # Instead, `application#index` renders its template without a redirect.
  sig { void }
  def index; end

  sig { void }
  def download
    respond_to do |format|
      format.html do; end
      format.json do
        unless user_signed_in? && current_user.can_access_fact_check_insights?
          render json: {
            error: "You do not have permission to view that resource."
          }, status: :unauthorized
          return
        end

        send_data(generate_json, type: "application/json", filename: "fact_check_insights.json")
      end

      format.zip do
      end
    end
  end

  sig { void }
  def guide; end

  sig { void }
  def highlights; end

  sig { void }
  def terms; end

  sig { void }
  def privacy; end

  sig { void }
  def optout; end

private

  sig { returns(String) }
  def generate_json
    all_claim_reviews = ClaimReview.all.map { |claim_review| JSON.parse(claim_review.render_for_export) }
    all_media_reviews = MediaReview.all.map { |media_review| JSON.parse(media_review.render_for_export) }
    metadata = {
      "retrievedAt": Time.now,
      "claimReviewCount": all_claim_reviews.length,
      "mediaReviewCount": all_media_reviews.length
    }

    JSON.pretty_generate({ "claimReviews": all_claim_reviews, "mediaReviews": all_media_reviews, "meta": metadata })
  end

  sig { returns(T::Boolean) }
  def generate_csv_zip
    # TODO: Fill this out with real data. #275
    true
  end
end
