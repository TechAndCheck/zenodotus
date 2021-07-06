# typed: ignore

class ArchiveController < ApplicationController
  # It's the index, list all the archived items
  sig { void }
  def index
    # @item_match = []
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
    # Retrieves media items if their associated usernames or text attributes match the search_term
    @results_ig_posts = InstagramPost.joins(%(INNER JOIN instagram_users on instagram_users.id=instagram_posts.author_id
                                             WHERE instagram_users.display_name ~* '#{params[:search_term]}'
                                             OR instagram_posts.text~* '#{params[:search_term]}'
                        ))
    @results_tweets = Tweet.joins(%(INNER JOIN twitter_users on twitter_users.id=tweets.author_id
                   WHERE twitter_users.display_name ~* '#{params[:search_term]}'
                   OR tweets.text ~* '#{params[:search_term]}'
                ))

    # Retrieves user items if their names match the search term
    @results_ig_users = InstagramUser.where("display_name ~* :search_term OR handle ~* :search_term", { search_term: params[:search_term] })
    @results_twitter_users = TwitterUser.where("display_name ~* :search_term OR handle ~* :search_term", { search_term: params[:search_term] })

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
