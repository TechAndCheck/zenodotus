# typed: true
class CreateMediaItems < ActiveRecord::Migration[6.1]
  def change
    create_table :media_items, id: :uuid do |t|
      t.uuid :mediable_id
      t.string :mediable_type
      t.timestamps
    end
  end
end
