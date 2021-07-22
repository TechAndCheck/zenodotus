class UnifiedUser < ApplicationRecord
  include PgSearch::Model
  self.primary_key = :author_id

  pg_search_scope(
    :search_users,
    against: :tsv_document,
    using: {
      tsearch: {
        tsvector_column: 'tsv_document',
        # prefix: true  # do we really want this for user searches?
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
