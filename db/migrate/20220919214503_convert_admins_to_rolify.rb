class ConvertAdminsToRolify < ActiveRecord::Migration[7.0]
  def up
    User.where(super_admin: true).each { |admin| admin.add_role :admin }

    remove_column :users, :super_admin
  end
  def down
    add_column :users, :super_admin, :boolean, default: false

    User.with_role(:admin).each do |admin|
      admin.update super_admin: true
      admin.remove_role :admin
    end
  end
end
