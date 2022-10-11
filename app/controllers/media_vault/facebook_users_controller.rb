# typed: strict

class MediaVault::FacebookUsersController < MediaVaultController
  sig { void }
  def show
    @facebook_user = Sources::FacebookUser.find(params[:id])
    facebook_post_archive_items = ArchiveItem.includes(archivable_item: [:author, :images, :videos])
                                             .where(archivable_item_type: "Sources::FacebookPost")
    facebook_posts_by_user = facebook_post_archive_items.select { |t| t.facebook_post.author == @facebook_user }

    respond_to do |format|
      format.html { @archive_items = facebook_posts_by_user }
      format.json do
        send_data ArchiveItem.generate_pruned_json(facebook_posts_by_user),
          type: "application/json",
          filename: "#{@facebook_user.name.parameterize(separator: '_')}_facebook_archive.json"
      end
    end
  end
end
