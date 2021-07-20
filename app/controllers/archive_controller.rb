# typed: ignore

class ArchiveController < ApplicationController
  # It's the index, list all the archived items
  sig { void }
  def index
    @archive_items = ArchiveItem.includes({ archivable_item: [:author, :images, :videos] })
  end

  # A form for submitting URLs
  sig { void }
  def add; end

  # A class representing the allowed params into the `submit_url` endpoint
  class SubmitUrlParams < T::Struct
    const :url_to_archive, String
  end

  # Searches content tables for Regex matches on user-submitted search term.
  #
  # @param {search_term} a user-submitted search term
  def search
    @search_term = params[:search_term]
    @user_search_hits = UnifiedUser.where("display_name ~* '#{@search_term}'")
    @post_search_hits = UnifiedPost.where("text ~* '#{@search_term}'")

  end

  # Entry point for submitting a URL for archiving
  #
  # @params {url_to_archive} the url to pull in
  sig { void }
  def submit_url
    typed_params = TypedParams[SubmitUrlParams].new.extract!(params)
    url = typed_params.url_to_archive
    object_model = model_for_url(url)
    begin
      object_model.create_from_url(url)
    rescue StandardError => e
      respond_to do |format|
        error = "#{e.class} : #{e.message}"
        format.turbo_stream { render turbo_stream: [
          turbo_stream.replace("modal", partial: "archive/add", locals: { error: error }),
          turbo_stream.replace(
            "tweets_list",
            partial: "archive/tweets_list",
            locals: { archive_items: ArchiveItem.includes({
              archivable_item: [:author, :images, :videos]
            }) }
          )
        ] }
        format.html { redirect_to :root }
      end
      return
    end

    respond_to do |format|
      flash.now[:alert] = "Successfully archived your link!"
      format.turbo_stream { render turbo_stream: [
        turbo_stream.replace("flash", partial: "layouts/flashes", locals: { flash: flash }),
        turbo_stream.replace("modal", partial: "archive/add", locals: { render_empty: true }),
        turbo_stream.replace(
          "tweets_list",
          partial: "archive/tweets_list",
          locals: { archive_items: ArchiveItem.includes({ archivable_item: [:author] }) }
        )
      ] }
      format.html { redirect_to :root }
    end
  end
end
