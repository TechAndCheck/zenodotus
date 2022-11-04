class AddReviewerToApplicants < ActiveRecord::Migration[7.0]
  def change
    add_reference :applicants, :reviewer, index: true, type: :uuid
  end
end
