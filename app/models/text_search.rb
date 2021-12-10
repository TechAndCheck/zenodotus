# typed: ignore
class TextSearch < ApplicationRecord
  belongs_to :user, optional: false, class_name: "User"
  # Searches against all posts and users in the db, returning those which reference the user-provided term +query+
  #
  # @return An ordered array of search results
  def run
    {
      user_search_hits: UnifiedUser.search_users(self.query),
      post_search_hits: UnifiedPost.search_posts(self.query)
    }
  end
end
