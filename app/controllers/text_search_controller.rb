# typed: ignore

class TextSearchController < ApplicationController
  # A class representing the allowed params into the `index` endpoint

  sig { void }
  def index
    @search = TextSearch.new
    @results = nil # @search.run
  end

  # A class representing the allowed params into the `search` endpoint
  class SubmitUrlParams < T::Struct
    const :query, String
  end

  sig { void }
  def search
    typed_params = TypedParams[SubmitUrlParams].new.extract!(params)
    # Create a search object
    search = TextSearch.create(query: typed_params.query)
    results = search.run

    # # Add the search id so that we can adjust the URL and make the page reloadable
    response.headers["X-search-id"] = search.id

    respond_to do |format|
      format.turbo_stream { render turbo_stream: [
        turbo_stream.replace(
          "search_results",
          partial: "text_search/results",
          locals: { search: search, results: results }
        ) # ,
        # turbo_stream.replace(
        #   "search_item",
        #   partial: "text_search/search_item",
        #   locals: { search: search, results: results }
        # )
      ] }
      format.html { redirect_to :root }
    end
  end
end
