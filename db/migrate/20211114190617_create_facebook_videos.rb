class CreateFacebookVideos < ActiveRecord::Migration[6.1]
  def change
    create_table :facebook_videos, id: :uuid do |t|

      t.references :facebook_post, type: :uuid, foreign_key: true
      t.jsonb :video_data
      t.timestamps
    end
  end
end
#             :user,
#             :video_file_name,
#             :video_preview_image_file_name,
#             :video_preview_image_url
