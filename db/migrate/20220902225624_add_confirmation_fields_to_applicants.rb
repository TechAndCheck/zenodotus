class AddConfirmationFieldsToApplicants < ActiveRecord::Migration[7.0]
  def change
    add_column :applicants, :confirmation_token, :string
    add_column :applicants, :confirmed_at, :datetime
    add_column :applicants, :confirmation_sent_at, :datetime
    add_index :applicants, :confirmation_token, unique: true
  end
end
