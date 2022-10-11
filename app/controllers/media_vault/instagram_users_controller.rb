# typed: strict

class MediaVault::InstagramUsersController < MediaVaultController
  sig { void }
  def show
    @instagram_user = Sources::InstagramUser.find(params[:id])
    instagram_post_archive_items = ArchiveItem.includes(archivable_item: [:author, :images, :videos])
                                              .where(archivable_item_type: "Sources::InstagramPost")
    instagram_posts_by_user = instagram_post_archive_items.select { |t| t.instagram_post.author == @instagram_user }

    respond_to do |format|
      format.html { @archive_items = instagram_posts_by_user }
      format.json do
        send_data ArchiveItem.generate_pruned_json(instagram_posts_by_user),
          type: "application/json",
          filename: "#{@instagram_user.display_name.parameterize(separator: '_')}_instagram_archive.json"
      end
    end
  end
end
