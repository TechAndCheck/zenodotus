# typed: strict

class FacebookUsersController < ApplicationController
  before_action :authenticate_user!

  sig { void }
  def show
    @facebook_user = Sources::FacebookUser.find(params[:id])
    facebook_post_archive_items = ArchiveItem.includes(archivable_item: [:author, :images, :videos])
                                             .where(archivable_item_type: "Sources::FacebookPost")
    facebook_posts_by_user = facebook_post_archive_items.select { |t| t.facebook_post.author == @facebook_user }
    @archive_items = facebook_posts_by_user
  end

  # Exports all media items created by the currently viewed Facebook user to a JSON file
  sig { void }
  def export_facebook_user_data
    facebook_post_archive_items = ArchiveItem.includes(archivable_item: [:author])
                                             .where(archivable_item_type: "Sources::FacebookPost")
    facebook_user = Sources::FacebookUser.find(params[:id])
    facebook_posts_by_user = facebook_post_archive_items.select { |t| t.facebook_post.author == facebook_user }
    facebook_post_archive_json = ArchiveItem.prune_archive_items(facebook_posts_by_user)
    send_data facebook_post_archive_json,
              type: "application/json; header=present",
              disposition: "attachment; filename=#{facebook_user.name.parameterize(separator: '_')}_facebook_archive.json"
  end
end
