class AddTotpSecretToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :totp_secret, :string
  end
end
