# typed: strict

class MediaVault::ArchiveController < MediaVaultController
  before_action :authenticate_super_user!, only: [
    :add,
    :submit_url,
  ]

  skip_before_action :authenticate_user!, only: :scrape_result_callback
  skip_before_action :must_be_media_vault_user, only: :scrape_result_callback

  # It's the index, list all the archived items
  sig { void }
  def index
    respond_to do | format |
      @archive_items = ArchiveItem.includes(:media_review, { archivable_item: [:author, :images, :videos] }).limit(50).order("created_at DESC")
      format.html { render "index" }
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
      object_model.create_from_url!(url, current_user)
    rescue StandardError => e
      respond_to do |format|
        error = "#{e.class}: #{e.message}"
        format.turbo_stream { render turbo_stream: [
          turbo_stream.replace("modal", partial: "media_vault/archive/add", locals: { error: error }),
          turbo_stream.update(
            "recent_archived_items",
            partial: "media_vault/archive/archive_items",
            locals: { archive_items: ArchiveItem.includes({
              archivable_item: [:author, :images, :videos]
            }).order("created_at DESC") }
          )
        ] }
        format.html { redirect_to :root }
      end
      return
    end

    respond_to do |format|
      flash.now[:success] = "Successfully archived your link!"
      format.turbo_stream { render turbo_stream: [
        turbo_stream.replace("flash", partial: "layouts/flashes/turbo_flashes", locals: { flash: flash }),
        turbo_stream.replace("modal", partial: "media_vault/archive/add", locals: { render_empty: true }),
        turbo_stream.update(
          "recent_archived_items",
          partial: "media_vault/archive/archive_items",
          locals: { archive_items: ArchiveItem.includes({ archivable_item: [:author] }).order("created_at DESC") }
        )
      ] }
      format.html { redirect_to :root }
    end
  end

  # Export entire archive of reviewed media to a JSON File
  sig { void }
  def export_archive_data
    send_data ArchiveItem.generate_pruned_json,
      type: "application/json",
      filename: "media_vault_archive.json"
  end

  # A class representing the allowed params into the `submit_url` endpoint
  class ScrapeResultCallbackParams < T::Struct
    const :scrape_id, String
    const :scrape_result, Array
  end

  # When a scrape is over the scraper will call this
  sig { void }
  def scrape_result_callback
    begin
      parsed_params = JSON.parse(request.raw_post)
    rescue JSON::ParserError
      parsed_params = {}
    end

    render json: { error: "Missing scrape id" }, status: 404 and return unless parsed_params.has_key?("scrape_id")

    # Validate id for auth purposes (auth key too?)
    begin
      scrape = Scrape.find(parsed_params["scrape_id"])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Invalid scrape id" }, status: 404 and return
    end

    parsed_result = parsed_params["scrape_result"]

    # There's a bug in Hypatia where it may come in as a string, which we need to parse, or an object, where we make it an array
    begin
      parsed_result = JSON.parse(parsed_result)
    rescue TypeError
      parsed_result = [parsed_result]
    end

    scrape.fulfill(parsed_result)

    render plain: "OK", status: 200
  end
end
