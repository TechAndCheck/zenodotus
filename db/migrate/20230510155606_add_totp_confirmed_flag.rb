class AddTotpConfirmedFlag < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :totp_confirmed, :boolean, default: false, nil: false
  end
end
