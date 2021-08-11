# typed: ignore

class CreateApiKeys < ActiveRecord::Migration[6.1]
  def change
    create_table :api_keys, id: :uuid do |t|
      t.string :hashed_api_key
      t.references :user, type: :uuid, foreign_key: true
      t.date :last_used
      t.jsonb :usage_logs
      t.timestamps

      t.index :hashed_api_key
    end
  end
end
