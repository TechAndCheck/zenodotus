# typed: strict

class MediaVault::SearchController < MediaVaultController
  class SearchParams < T::Struct
    const :q, T.nilable(String)    # Text Query
    const :msid, T.nilable(String) # Media Search ID
  end
  class MediaSearchParams < T::Struct
    const :media, ActionDispatch::Http::UploadedFile
  end

  sig { void }
  def index
    typed_params = TypedParams[SearchParams].new.extract!(params)

    if params.has_key?(:q)
      search_by_text(typed_params.q)
    end

    if params.has_key?(:msid)
      search_by_media_search_id(typed_params.msid)
    end
  end

  # Search for archived items using a piece of media.
  #
  # Create an ImageSearch record and adds the ID to the URL so the search can be bookmarked and
  # repeated. This is achieved by returning the ID on the X-search-id header (for Turbo requests)
  # and by redirecting to the search index page with the ID on the query params (for standard
  # requests). Thus, we only run the search within this action for the Turbo requests.
  sig { void }
  def search_by_media
    typed_params = TypedParams[MediaSearchParams].new.extract!(params)

    @media_search = ImageSearch.create_with_media_item(typed_params.media, current_user)

    respond_to do |format|
      format.turbo_stream do
        # See #456 for why we aren't really using Turbo here.
        redirect_to media_vault_search_path(msid: @media_search.id)
      end
      format.html do
        redirect_to media_vault_search_path(msid: @media_search.id)
      end
    end
  end

private

  sig { params(id: String).void }
  def search_by_media_search_id(id)
    @media_search = ImageSearch.find(id)
    # TODO: This should be @post_results once we ensure it's the same return objects
    @media_results = @media_search.run

    rescue ActiveRecord::RecordNotFound
  end

  sig { params(query: String).void }
  def search_by_text(query)
    @query = query

    search = TextSearch.create!(query: @query, user: current_user)
    results = search.run

    # Split results into posts and users based on class.

    post_models = [
      Sources::Tweet,
      Sources::InstagramPost,
      Sources::FacebookPost,
      Sources::YoutubePost
    ]

    user_models = [
      Sources::FacebookUser,
      Sources::InstagramUser,
      Sources::TwitterUser,
      Sources::YoutubeChannel,
    ]

    @post_results = []
    @user_results = []

    results.each do |result|
      if post_models.include?(result.class)
        @post_results.append(result)
        next
      end

      if user_models.include?(result.class)
        @user_results.append(result)
      end
    end
  end
end
