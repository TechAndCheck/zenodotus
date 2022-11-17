# typed: strict

class MediaVault::MediaController < MediaVaultController
  sig { void }
  def show
    @archive_item = ArchiveItem.find(params[:id])
  end
end
