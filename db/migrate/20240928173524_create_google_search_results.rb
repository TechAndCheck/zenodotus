class CreateGoogleSearchResults < ActiveRecord::Migration[7.0]
  def change
    create_table :google_search_results, id: :uuid do |t|
      t.text      :text
      t.string    :claimant
      t.datetime  :claim_date
      t.string    :url
      t.datetime  :review_date
      t.string    :rating
      t.string    :title
      t.string    :language_code
      t.string    :publisher_name
      t.string    :publisher_site
      t.string    :image_url

      t.timestamps
    end
  end
end
