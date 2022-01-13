class AddOrganizationToUsers < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :organization, null: false, type: :uuid
  end
end
