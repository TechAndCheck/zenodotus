class AddCountryToApplicant < ActiveRecord::Migration[7.0]
  def change
    add_column :applicants, :country, :string
  end
end
