class CreateFacebookImages < ActiveRecord::Migration[6.1]
  def change
    create_table :facebook_images, id: :uuid do |t|
      t.references :facebook_post, type: :uuid, foreign_key: true
      t.jsonb :image_data
      t.string :dhash
      t.timestamps
    end
  end
end
