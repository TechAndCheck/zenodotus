class AddStoredTsVectorToPgSearchDocuments < ActiveRecord::Migration[7.0]
  def change
    add_column :pg_search_documents, :content_tsvector, :virtual, type: :tsvector,  as: "to_tsvector('english', content)", stored: true
  end
end
