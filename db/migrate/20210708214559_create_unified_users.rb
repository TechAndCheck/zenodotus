class CreateUnifiedUsers < ActiveRecord::Migration[6.1]
  def change
    create_view :unified_users
  end
end
