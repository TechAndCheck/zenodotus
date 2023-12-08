class CreateCorpusDownloads < ActiveRecord::Migration[7.0]
  def change
    create_table :corpus_downloads, id: :uuid do |t|
      t.integer :download_type, null: false
      t.belongs_to :user, type: :uuid, null: false, foreign_key: true
      t.timestamps
    end
  end
end
