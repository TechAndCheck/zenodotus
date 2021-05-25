# typed: true

class MediaController < ApplicationController
  def index
    @tweets = Tweet.all
  end

  def add; end

  def submit_url
    url = params[:url_to_archive]
    birdsong_tweet = TwitterMediaSource.extract(url)
    tweet = Tweet.create_from_birdsong_hash(birdsong_tweet)

    respond_to do |format|
      flash.now[:alert] = "Successfully archived your link!"
      format.turbo_stream { render turbo_stream: [
        turbo_stream.replace("flash", partial: "layouts/flashes", locals: { flash: flash }),
        turbo_stream.replace("modal", partial: "media/add", locals: { render_empty: true }),
        turbo_stream.replace("tweets_list", partial: "media/tweets_list", locals: { tweets: Tweet.all })
      ] }
      format.html { redirect_to :root }
    end
  end
end
