class PublicAccess::MediaController < ApplicationController
  sig { void }
  def index
    @page_metadata = { title: "Archive", description: "Archive" }
  end

  sig { void }
  def show
    @archive_item = ArchiveItem.find_by(public_id: params[:public_id])
    description = @archive_item.normalized_attrs_for_views[:archive_item_caption].present? ? "“#{@archive_item.normalized_attrs_for_views[:archive_item_caption]}”" : "(uncaptioned media)"
    images = @archive_item.images.map { |image| image.image.download_url }
    videos = @archive_item.videos.map { |video| video.video_derivatives[:preview].download_url }
    @page_metadata = { title: "Archive", description: description, images: images, videos: videos }
  end
end
