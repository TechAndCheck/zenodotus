# typed: strict

class FactCheckInsightsController < ApplicationController
  # We don't route to this URL directly.
  # Instead, `application#index` renders its template without a redirect.
  sig { void }
  def index; end

  sig { void }
  def download
    respond_to do |format|
      format.html do; end # Just show the page
      format.any(:zip, :json) do # Download the appropriate file
        unless user_signed_in? && current_user.can_access_fact_check_insights?
          render json: {
            error: "You do not have permission to view that resource."
          }, status: :unauthorized
          return
        end

        file_name = request.format == :json ? "exports/fact_check_insights.json" : "exports/fact_check_insights.zip"
        # Generate public signed link for the file on AWS
        json_presigned_url = get_presigned_url_for_s3_file(file_name)

        # Redirect to that file
        redirect_to json_presigned_url.to_s, allow_other_host: true
      end
    end
  rescue Aws::Errors::ServiceError
    render json: {
      error: "An error has occured trying to download the file. We've been notified, Please try again later."
    }, status: :internal_server_error
  end

  sig { void }
  def guide; end

  sig { void }
  def highlights; end

  sig { void }
  def optout; end

private

  def get_presigned_url_for_s3_file(filename)
    # Generate public signed link for the file on AWS
    bucket = Aws::S3::Bucket.new(Figaro.env.AWS_S3_BUCKET_NAME)
    json_url = bucket.object(filename).presigned_url(:get)
    URI(json_url)
  rescue Aws::Errors::ServiceError => e
    logger.info "Couldn't create presigned URL for #{bucket.name}:#{json_url} . Here's why: #{e.message}"
    Honeybadger.notify(e)
    raise e
  end
end
