class AddNameToUser < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :name, :string

    User.all.each do |user|
      name = user.applicant.present? ? user.applicant.name : user.email
      user.update(name: name)
    end

    # Have to run this after the fields have been populated, since they're null at first.
    change_column_null :users, :name, false
  end

  def down
    remove_column :users, :name
  end
end
