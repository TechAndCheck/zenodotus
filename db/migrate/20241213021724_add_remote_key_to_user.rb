class AddRemoteKeyToUser < ActiveRecord::Migration[7.2]
  def change
    create_table :user_remote_keys, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.string :hashed_remote_key, null: false
      t.datetime :expires_at
      t.datetime :last_used_at
      t.string :last_used_ip
      t.string :last_used_user_agent
      t.string :last_used_referer
      t.string :last_used_origin
      t.string :last_used_path
      t.string :last_used_method

      t.timestamps

      t.index :hashed_remote_key, unique: true
    end

    add_column :users, :remote_key_id, :uuid
  end
end
