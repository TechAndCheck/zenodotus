class AddVideoToImageSearch < ActiveRecord::Migration[7.0]
  def change
    add_column :image_searches, :video_data, :jsonb
  end
end
