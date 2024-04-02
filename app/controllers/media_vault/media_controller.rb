# typed: strict

class MediaVault::MediaController < MediaVaultController
  before_action :find_archive_item, :verify_ownership

  sig { void }
  def find_archive_item
    @archive_item = ArchiveItem.find(params[:id])

    if @archive_item.nil?
      flash[:error] = "Media item not found."
      redirect_to media_vault_dashboard_path
    end
  end

  sig { void }
  def verify_ownership
    unless current_user
      flash[:error] = "You must be logged in to access this page."
      redirect_to new_user_session_path
      return
    end

    if @archive_item.private && !@archive_item.users.include?(current_user)
      flash[:error] = "You do not have permission to view this item."
      redirect_to media_vault_dashboard_path
    end
  end

  sig { void }
  def show
    @myvault = @archive_item.private
  end

  sig { void }
  def destroy
    # Make sure the current user actually owns this piece of media
    unless @archive_item.private
      flash[:error] = "You do not have permission to delete this item."
      redirect_to media_vault_dashboard_path
      return
    end

    unless @archive_item.users.include?(current_user)
      flash[:error] = "You do not have permission to delete this item."
      redirect_to media_vault_dashboard_path(myvault: true)
      return
    end

    @archive_item.destroy

    flash[:success] = "MyVault item successfully deleted."
    redirect_to media_vault_dashboard_path(myvault: true)
  end

  # Exports JSON-formatted metadata about a piece of media
  sig { void }
  def export_metadata
    archive_item = ArchiveItem.includes(:media_review, archivable_item: [:author]).find(params[:id])

    # Parse JSON string, extract first (and only) item from array, then convert back to a string
    archive_item_export = JSON.pretty_generate(JSON.parse(ArchiveItem.generate_json_for_export([archive_item])).first)

    send_data archive_item_export,
      type: "application/json",
      filename: "media_metadata.json"
  end
end
