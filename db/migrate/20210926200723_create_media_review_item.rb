class CreateMediaReviewItem < ActiveRecord::Migration[6.1]
  def change
    create_table :media_review_items, id: :uuid do |t|
    end
  end
end
