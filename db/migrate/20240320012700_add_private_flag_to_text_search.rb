class AddPrivateFlagToTextSearch < ActiveRecord::Migration[7.0]
  def change
    add_column :text_searches, :private, :boolean, default: false, null: false
  end
end
