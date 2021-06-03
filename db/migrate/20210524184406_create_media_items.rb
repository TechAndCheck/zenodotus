# typed: true
class CreateMediaItems < ActiveRecord::Migration[6.1]
  def change
    create_table :archive_items, id: :uuid do |t|
      t.uuid :archivable_item_id
      t.string :archivable_item_type
      t.timestamps
    end

    create_table :archive_entities, id: :uuid do |t|
      t.uuid :archivable_entity_id
      t.string :archivable_entity_type
      t.timestamps
    end
  end
end
