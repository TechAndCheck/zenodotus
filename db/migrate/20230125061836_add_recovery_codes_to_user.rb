class AddRecoveryCodesToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :hashed_recovery_codes, :string, array: true, null: false, default: []
  end
end
