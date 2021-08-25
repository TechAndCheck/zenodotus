# typed: ignore

class TextSearchController < ApplicationController
  sig { void }
  def index
    @search = TextSearch.new
    @results = nil
  end

  # A class representing the allowed params into the `search` endpoint
  class SubmitUrlParams < T::Struct
    const :query, String
  end

  # Searches for posts and authors matching a search term
  #
  # @param {search_term} a user-submitted search term
  sig { void }
  def search
    typed_params = TypedParams[SubmitUrlParams].new.extract!(params)
    # Create a search object
    search = TextSearch.create(query: typed_params.query)
    results = search.run
    @user_search_hits = results[:user_search_hits]
    @post_search_hits = results[:post_search_hits]
  end
end
