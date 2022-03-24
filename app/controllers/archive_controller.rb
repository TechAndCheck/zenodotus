# typed: strict

class ArchiveController < ApplicationController
  # It's the index, list all the archived items

  before_action :authenticate_user!, except: :scrape_result_callback

  sig { void }
  def index
    respond_to do | format |
      if current_user.nil? || current_user.restricted
        @archive_items = ArchiveItem.includes(:media_review, archivable_item: [:author])
        format.html { render "limited_index" }
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
    typed_params = TypedParams[SubmitUrlParams].new.extract!(params)
    url = typed_params.url_to_archive
    object_model = ArchiveItem.model_for_url(url)
    begin
      object_model.create_from_url(url, current_user)
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

  # Export entire archive of reviewed media to a JSON File
  sig { void }
  def export_archive_data
    archive_json = ArchiveItem.prune_archive_items
    send_data archive_json, type: "application/json; header=present", disposition: "attachment; filename=archive.json"
  end

  # A class representing the allowed params into the `submit_url` endpoint
  class ScrapeResultCallbackParams < T::Struct
    const :scrape_id, String
    const :scrape_result, Array
  end

  # When a scrape is over the scraper will call this
  sig { void }
  def scrape_result_callback
    print "**************\n"
    print "params: #{params}\n"
    print "**************\n"

    render json: { error: "Missing scrape id" }, status: 404 and return unless params.has_key?(:scrape_id)

    typed_params = TypedParams[ScrapeResultCallbackParams].new.extract!(JSON.parse(params))

    # Validate id for auth purposes (auth key too?)
    begin
      scrape = Scrape.find(typed_params.scrape_id)
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Invalid scrape id" }, status: 404 and return
    end

    scrape.fulfill(typed_params.scrape_result.first)
  end
end
