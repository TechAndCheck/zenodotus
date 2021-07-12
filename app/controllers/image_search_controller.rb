# typed: ignore

class ImageSearchController < ApplicationController
  sig { void }
  def index
    @search = ImageSearch.new
  end

  # A class representing the allowed params into the `search` endpoint
  class SubmitUrlParams < T::Struct
    const :image, ActionDispatch::Http::UploadedFile
  end

  sig { void }
  def search
    # jard
    typed_params = TypedParams[SubmitUrlParams].new.extract!(params[:image_search])
    # Create a search object
    search = ImageSearch.create({ image: typed_params.image })
    results = search.run

    respond_to do |format|
      format.turbo_stream { render turbo_stream: [
        turbo_stream.replace(
          "search_results",
          partial: "image_search/results",
          locals: { search: search, results: results }
        ),
      ] }
      format.html { redirect_to :root }
    end
  end
end
