# typed: strict

class MediaVault::MediaController < MediaVaultController
  sig { void }
  def show
    @archive_item = ArchiveItem.find(params[:id])
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
