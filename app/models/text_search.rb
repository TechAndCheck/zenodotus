# typed: ignore
class TextSearch < ApplicationRecord
  belongs_to :user, optional: false, class_name: "User"

  # Searches against posts and users in the db, returning those which reference the search term +query+
  #
  # @return An ActiveRecord relation of matching records across all media source models
  def run
    PgSearch.multisearch(self.query).includes(:searchable).map { |document| document.searchable }
  end
end
