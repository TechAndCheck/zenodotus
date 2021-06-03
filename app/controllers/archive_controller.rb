# typed: true

class ArchiveController < ApplicationController
  def index
    @archive_items = ArchiveItem.tweets.includes([:archivable_item])
  end

  def add; end

  def submit_url
    url = params[:url_to_archive]
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
