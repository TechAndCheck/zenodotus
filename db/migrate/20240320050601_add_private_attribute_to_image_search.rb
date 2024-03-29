class AddPrivateAttributeToImageSearch < ActiveRecord::Migration[7.0]
  def change
    add_column :image_searches, :private, :boolean, default: false, null: false
  end
end
