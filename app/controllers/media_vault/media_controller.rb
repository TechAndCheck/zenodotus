# typed: strict

class MediaVault::MediaController < ApplicationController
  sig { void }
  def show
    @archive_item = ArchiveItem.find(params[:id])
  end
end
