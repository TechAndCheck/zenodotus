class PublicAccess::MediaController < ApplicationController
  sig { void }
  def index; end

  sig { void }
  def show
    @archive_item = ArchiveItem.find_by(public_id: params[:public_id])
  end
end
