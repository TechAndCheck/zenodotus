class InstagramUsersController < ApplicationController
  def show
    @instagram_user = Sources::InstagramUser.find(params[:id])
    @archive_items = Sources::InstagramPost.where(author_id: @instagram_user.id).includes([:images, :videos])
  end

  # Exports all media items created by the currently viewed Instagram user to a JSON file
  def export_instagram_user_data
    instagram_post_archive_items = ArchiveItem.includes(archivable_item: [:author])
                                     .where(archivable_item_type: "Sources::InstagramPost")
    instagram_user = Sources::InstagramUser.find(params[:id])
    instagram_posts_by_user = instagram_post_archive_items.select { |t| t.instagram_post.author == instagram_user }
    instagram_post_archive_json = ArchiveItem.prune_archive_items(instagram_posts_by_user)
    send_data instagram_post_archive_json,
              type: "application/json; header=present",
              disposition: "attachment; filename=#{instagram_user.display_name.parameterize(separator: '_')}_instagram_archive.json"
  end
end
