class AddStatusToApplicants < ActiveRecord::Migration[7.0]
  def change
    create_enum :applicant_status, ["approved", "rejected"]

    add_column :applicants, :status, :enum, enum_type: :applicant_status
    add_column :applicants, :reviewed_at, :timestamp
    add_column :applicants, :review_note, :text
    add_column :applicants, :review_note_internal, :text
  end
end
