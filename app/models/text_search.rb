# typed: strict

class TextSearch < ApplicationRecord
  belongs_to :user, optional: false, class_name: "User"

  # Searches against posts and users in the db, returning those which reference the search term +query+
  #
  # @return An array of matching records across all media source models
  sig { returns(T::Array[ArchivableItem]) }
  def run
    # TODO: Optimize this query to avoid sorting the entire set of ArchivableItems (#129)
    if self.private
      search = PgSearch.multisearch(self.query).where("'#{user.id}'=ANY(user_id)", private: true)
    else
      search = PgSearch.multisearch(self.query).where(private: false)
    end

    search.includes(searchable: %i(author images videos)).map { |document | document.searchable }
  end
end
