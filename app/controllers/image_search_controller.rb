# typed: ignore

class ImageSearchController < ApplicationController

  # before_action :authenticate_user!
  # A class representing the allowed params into the `index` endpoint
  class IndexUrlParams < T::Struct
    const :q_id, T.nilable(String)
  end

  sig { void }
  def index
    typed_params = TypedParams[IndexUrlParams].new.extract!(params)

    @search = ImageSearch.new
    unless typed_params.q_id.nil?
      begin
        @search = ImageSearch.find(typed_params.q_id)
      rescue ActiveRecord::RecordNotFound
        # Eat this and just stick with the new one.
      end
    end

    @results = @search.run unless @search.id.nil?
  end

  # A class representing the allowed params into the `search` endpoint
  class SubmitUrlParams < T::Struct
    const :image, ActionDispatch::Http::UploadedFile
  end

  sig { void }
  def search
    typed_params = TypedParams[SubmitUrlParams].new.extract!(params[:image_search])
    # Create a search object
    search = ImageSearch.create({ image: typed_params.image })
    results = search.run

    # Add the search id so that we can adjust the URL and make the page reloadable
    response.headers["X-search-id"] = search.id

    respond_to do |format|
      format.turbo_stream { render turbo_stream: [
        turbo_stream.replace(
          "search_results",
          partial: "image_search/results",
          locals: { search: search, results: results }
        ),
        turbo_stream.replace(
          "search_item",
          partial: "image_search/search_item",
          locals: { search: search, results: results }
        )
      ] }
      format.html { redirect_to :root }
    end
  end
end
