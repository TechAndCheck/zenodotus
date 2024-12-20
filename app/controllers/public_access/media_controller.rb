class PublicAccess::MediaController < ApplicationController
  caches_action :index, :show, expires_in: 5.minutes

  sig { void }
  def index
    @page_metadata = { title: "Archive", description: "Archive" }
  end

  sig { void }
  def show
    @archive_item = ArchiveItem.find_by(public_id: params[:public_id])

    if @archive_item.nil?
      render status: :not_found # TODO: Write a test for this!
      return
    end

    description = @archive_item.normalized_attrs_for_views[:archive_item_caption].present? ? "“#{@archive_item&.normalized_attrs_for_views[:archive_item_caption]}”" : "(uncaptioned media)"
    images = @archive_item.images.map { |image| image.image.download_url }
    images.concat @archive_item.videos.map { |video| video.video_derivatives[:preview].download_url } # Add videos as images since that's fine for previews too'
    videos = @archive_item.videos.map { |video| video.video.download_url }

    @page_metadata = { title: "Archive", description: description, images: images, videos: videos }
  end
end
