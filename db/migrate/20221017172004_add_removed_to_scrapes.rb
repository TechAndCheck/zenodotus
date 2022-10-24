class AddRemovedToScrapes < ActiveRecord::Migration[7.0]
  def change
    add_column :scrapes, :removed, :boolean, default: false
  end
end
