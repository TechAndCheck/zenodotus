class RemoveRestrictedFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :restricted, :boolean, null: false, default: false
  end
end
