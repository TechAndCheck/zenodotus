class AddTypeToWebauthnCredentials < ActiveRecord::Migration[7.0]
  def change
    add_column :webauthn_credentials, :key_type, :string, null: false
  end
end
