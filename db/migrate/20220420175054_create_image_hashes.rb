class CreateImageHashes < ActiveRecord::Migration[7.0]
  def change
    create_table :image_hashes, id: :uuid do |t|
      t.string :dhash, required: true
      t.uuid :archive_item_id, required: true
      t.timestamps
    end
  end
end
