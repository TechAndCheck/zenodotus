# typed: ignore
class AddPgcryptoExtension < ActiveRecord::Migration[6.1]
  def change
    enable_extension "pgcrypto"
  end
end
