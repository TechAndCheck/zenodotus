# typed: ignore

class ArchiveController < ApplicationController
  # It's the index, list all the archived items

  # before_action :authenticate_user!
  # before_action :require_login, only: [:submit_url ]

  # def require_login
  #   unless user_signed_in?
  #     respond_to do |format|
  #       format.html { redirect_to new_user_session_path }
  #     end
  #   end
  # end

  sig { void }
  def index
    # @archive_items = ArchiveItem.includes({ archivable_item: [:author, :images, :videos] })
    respond_to do | format |
      if current_user.nil? || current_user.restricted
        @archive_items = ArchiveItem.includes(:media_review) #, archivable_item: [:author])
        format.html { render "limited_index"}
      else
        @archive_items = ArchiveItem.includes(:media_review, { archivable_item: [:author, :images, :videos] })
        format.html {  render "index" }
      end

    end
  end

  # A form for submitting URLs
  sig { void }
  def add; end

  # A class representing the allowed params into the `submit_url` endpoint
  class SubmitUrlParams < T::Struct
    const :url_to_archive, String
  end

  # Entry point for submitting a URL for archiving
  #
  # @params {url_to_archive} the url to pull in
  sig { void }
  def submit_url
    # unless user_signed_in?
    #   format.html { redirect_to :new_user_session_path }
    #   return
    # end
    typed_params = TypedParams[SubmitUrlParams].new.extract!(params)
    url = typed_params.url_to_archive
    object_model = ArchiveItem.model_for_url(url)
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
      # need to check for restricted users here, too
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
