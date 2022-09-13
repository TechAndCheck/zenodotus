class AddUserToApplicants < ActiveRecord::Migration[7.0]
  def change
    add_reference :applicants, :user, index: true, type: :uuid
  end
end
