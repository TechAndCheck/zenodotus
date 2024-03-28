class AddPrivateAttributeToPgSearchDocuments < ActiveRecord::Migration[7.0]
  def change
    add_column :pg_search_documents, :private, :boolean, null: false, default: false
    add_column :pg_search_documents, :user_id, :uuid, array: true
  end
end
