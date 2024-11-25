class MediaVault::ApiController < MediaVaultController
  respond_to :json
  before_action :drop_session_cookie

  def submit
    render json: { success: true }
  end

  private

    def drop_session_cookie
      request.session_options[:skip] = true
    end
end
