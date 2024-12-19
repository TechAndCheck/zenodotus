class MediaVault::ApiController < MediaVaultController
  respond_to :json

  skip_before_action :authenticate_user_and_setup!, :must_be_media_vault_user
  # For a fun bug, there's a `before_action :must_be_media_vault_user` in the parent class
  # So we need to skip it first, then re-enable it here after authenticating.
  before_action :authenticate_user_from_remote_key!, :must_be_media_vault_user, except: [:check_if_logged_in]

  def check_if_logged_in
    remote_key = params["auth_key"]
    if remote_key.blank? || !current_user&.valid_remote_key?(remote_key) || !current_user.can_access_media_vault?
      sleep(1) # This is to slow down brute force attacks
      status = :unauthorized
      json = { error: "You are not authorized to access that resource." }
    else
      status = :ok
      json = { success: true }
    end

    respond_to do |format|
      format.json { render json: json, status: status }
    end
  end

  def submit
    # Note that this is done in `archive_controller.rb` as well, so if you change it here, change it there too
    url = params[:url]
    if url.nil?
      respond_to do |format|
        format.json do
          render json: { error: { title: "Error Submitting Request", body: "No URL was provided" } }
        end
      end && return
    end

    object_model = ArchiveItem.model_for_url(url)

    # If there's no object_model then we don't have that URL
    if object_model.nil?
      respond_to do |format|
        format.json do
          render json: { error: { title: "Error Submitting Request", body: "Unsupported URL" } }
        end
      end && return
    end

    # Try to start the scrape, otherwise... error out again
    begin
      object_model.create_from_url(url, current_user)
    rescue StandardError => e
      Honeybadger.notify(e)

      respond_to do |format|
        format.json do
          render json: { error: { title: "Error Submitting Request", body: "An unexpected error has been raised submitting your request. We've been notified and will be looking into it shortly." } }
        end
      end && return
    end

    # WOOOOO
    respond_to do |format|
      format.json { render json: { success: true } }
    end
  end
end
