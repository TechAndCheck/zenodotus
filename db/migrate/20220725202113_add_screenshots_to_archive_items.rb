class AddScreenshotsToArchiveItems < ActiveRecord::Migration[7.0]
  def change
    create_table :screenshots, id: :uuid do |t|
      t.references :archive_item, type: :uuid, foreign_key: true
      t.jsonb      :image_data
      t.timestamps
    end
  end
end
