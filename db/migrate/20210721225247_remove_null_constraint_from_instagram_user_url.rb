# typed: ignore

class RemoveNullConstraintFromInstagramUserUrl < ActiveRecord::Migration[6.1]
  def change
    change_column_null :instagram_users, :url, true
  end
end
