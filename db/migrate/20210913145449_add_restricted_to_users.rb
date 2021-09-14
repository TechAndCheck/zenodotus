class AddRestrictedToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :restricted, :boolean, null: false, default: false
  end
end
