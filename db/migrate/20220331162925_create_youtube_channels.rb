class CreateYoutubeChannels < ActiveRecord::Migration[7.0]
  def change
    create_table :youtube_channels, id: :uuid do |t|
      t.string :title, null: false
      t.string :youtube_id, null: false
      t.integer :num_views, null: false
      t.integer :num_subscribers, null: false
      t.integer :num_videos, null: false
      t.boolean :made_for_kids, null: false
      t.datetime :sign_up_date, null: false
      t.jsonb :channel_image_data, null: false
      t.string :channel_image_url
      t.string :description
      t.timestamps
    end
  end
end
