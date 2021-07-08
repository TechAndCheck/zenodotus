# typed: ignore

class ImageSearchController < ApplicationController
  sig { void }
  def index; end

  # A class representing the allowed params into the `search` endpoint
  class SubmitUrlParams < T::Struct
    const :image, ActionDispatch::Http::UploadedFile
  end

  sig { void }
  def search
    typed_params = TypedParams[SubmitUrlParams].new.extract!(params)
    # Create a search object
    search = Search.create(typed_params)
    @results = search.run
  end
end
