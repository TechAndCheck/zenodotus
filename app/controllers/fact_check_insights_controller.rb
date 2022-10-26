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

        send_data(generate_json,
          type: "application/json",
          filename: "fact_check_insights_data.json"
        )
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
    # TODO: Fill this out with real data. #275
    {}.to_json
  end
end
