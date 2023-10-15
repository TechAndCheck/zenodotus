class AddMediaReviewLinkToScrape < ActiveRecord::Migration[7.0]
  def change
    add_reference :scrapes, :media_review, type: :uuid
  end
end
