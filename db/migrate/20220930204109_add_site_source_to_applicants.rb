class AddSiteSourceToApplicants < ActiveRecord::Migration[7.0]
  def change
    add_column :applicants, :source_site, :string
  end
end
