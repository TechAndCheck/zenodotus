class UpdateUnifiedUsersToVersion2 < ActiveRecord::Migration[6.1]
  def change
    update_view :unified_users,
      version: 2,
      revert_to_version: 1,
      materialized: true
  end
end
