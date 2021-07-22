class UnifiedPost < ApplicationRecord
  include PgSearch::Model

  self.primary_key = :post_id  # think I need this for the query generation.

  # pg_search_scope :search_by_text, against: :text
  pg_search_scope(
    :search_,
    against: :tsv_document,
    using: {
      tsearch: {
        # dictionary: 'english'  #TODO: Uncomment line to enable stemming
        tsvector_column: 'tsv_document',
        prefix: true,
      }
    }
  )

  def readonly?
    true
  end

  def self.refresh
    Scenic.database.refresh_materialized_view(table_name, concurrently: true, cascade: false)
  end
end
