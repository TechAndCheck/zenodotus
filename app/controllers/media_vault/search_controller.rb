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
      # Check if the query is a url, if so, try to download it
      begin
        uri = URI.parse(typed_params.q)
        uri && uri.host.present? # This is just a check if it a URL, we don't care about the results
        search_by_url(typed_params.q) if uri.class == URI::HTTP || uri.class == URI::HTTPS # URI Can parse just regular strings, so we make sure it's not
      rescue URI::InvalidURIError; end # Do nothing, just do a regular text search

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
    @results = @media_search.run
    @post_results = @results.filter_map { |result|
      result.has_key?(:image) ? result[:image] : (
        result.has_key?(:video) ? result[:video] : nil
      )
    }
  rescue ActiveRecord::RecordNotFound
  end

  sig { params(query: String).void }
  def search_by_text(query)
    @query = query

    search = TextSearch.create!(query: @query, user: current_user)
    @results = search.run

    # Split results into posts and authors based on class.

    post_models = [
      Sources::Tweet,
      Sources::InstagramPost,
      Sources::FacebookPost,
      Sources::YoutubePost
    ]

    author_models = [
      Sources::FacebookUser,
      Sources::InstagramUser,
      Sources::TwitterUser,
      Sources::YoutubeChannel,
    ]

    @post_results = []
    @author_results = []

    @results.each do |result|
      if post_models.include?(result.class)
        @post_results.append(result.archive_item) unless result.archive_item.nil?
        next
      end

      if author_models.include?(result.class)
        @author_results.append(result) unless result.nil?
        next
      end

      # At this point it's in MediaReview but we'll only return it if we have something in the archive
      # Check if it's a MediaReview or ClaimReview
      #
      # A switch statement doesn't work here, thus the if/else tree
      if result.class == MediaReview
        @post_results.append(result.archive_item) unless result.archive_item.nil?
      elsif result.class == ClaimReview
        @post_results.append(result.media_review.archive_item) if result.media_review&.archive_item
      end
    end
  end

  # This downloads a file and then searches it. It streams it in since we have no idea if it's small or big
  sig { params(url: String).void }
  def search_by_url(url)
    downloaded_file = Shrine.remote_url(url)
    @media_search = ImageSearch.create_with_media_item(downloaded_file, current_user)

    respond_to do |format|
      format.turbo_stream do
        # See #456 for why we aren't really using Turbo here.
        redirect_to media_vault_search_path(msid: @media_search.id)
      end
      format.html do
        redirect_to media_vault_search_path(msid: @media_search.id)
      end
    end
  rescue Shrine::Plugins::RemoteUrl::DownloadError, RuntimeError => e
    flash[:error] = case e.message
                    when "remote file too large"
                      "The file you wanted to search is too large. You will have to make a clip that is less than 20mb."
                    when "remote file not found"
                      "The URL you entered could not be found. Please check that it's correct or try another."
                    when "Invalid media uploaded."
                      "The URL you entered is not a valid media file. Please check that it's correct or try another."
                    else
                      "The URL you entered could not be downloaded. Please check that it's correct or try another."
    end

    respond_to do |format|
      format.turbo_stream do
        # See #456 for why we aren't really using Turbo here.
        redirect_back(fallback_location: media_vault_root_path)
      end
      format.html do
        redirect_back(fallback_location: media_vault_root_path)
      end
    end
  end
end
