# typed: ignore
class TextSearch < ApplicationRecord
  belongs_to :user, optional: false, class_name: "User"

  # Searches against posts and users in the db, returning those which reference the search term +query+
  #
  # @return An ActiveRecord relation of matching records across all media source models
  def run
    # TODO: Optimize this query to avoid sorting the entire set of ArchivableItems (#129)
    PgSearch.multisearch(self.query).includes(searchable: [:author, :images, :videos]).map { |document| document.searchable }
  end
end
