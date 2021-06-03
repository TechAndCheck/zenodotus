# typed: ignore

class ArchiveController < ApplicationController
  # It's the index, list all the archived items
  sig { void }
  def index
    @archive_items = ArchiveItem.tweets.includes({ archivable_item: [:author] })
  end

  # A form for submitting URLs
  sig { void }
  def add; end

  # Entry point for submitting a URL for archiving
  #
  # @params {url_to_archive} the url to pull in
  class SubmitUrlParams < T::Struct
    const :url_to_archive, String
  end

  sig { void }
  def submit_url
    typed_params = TypedParams[SubmitUrlParams].new.extract!(params)
    url = typed_params[:url_to_archive]
    birdsong_tweet = TwitterMediaSource.extract(url)
    Tweet.create_from_birdsong_hash(birdsong_tweet)

    respond_to do |format|
      flash.now[:alert] = "Successfully archived your link!"
      format.turbo_stream { render turbo_stream: [
        turbo_stream.replace("flash", partial: "layouts/flashes", locals: { flash: flash }),
        turbo_stream.replace("modal", partial: "archive/add", locals: { render_empty: true }),
        turbo_stream.replace(
          "tweets_list",
          partial: "archive/tweets_list",
          locals: { archive_items: ArchiveItem.tweets.includes([:archivable_item]) }
        )
      ] }
      format.html { redirect_to :root }
    end
  end
end
