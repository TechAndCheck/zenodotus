# typed: strict

class MediaVault::ArchiveController < MediaVaultController
  before_action :authenticate_super_user!, only: [
    :add,
    :submit_url,
  ]

  skip_before_action :authenticate_user_and_setup!, only: :scrape_result_callback
  skip_before_action :must_be_media_vault_user, only: :scrape_result_callback

  ARCHIVE_ITEMS_PER_PAGE = 15

  # It's the index, list all the archived items
  sig { void }
  def index
    @pagy_archive_items, @archive_items = pagy(
      ArchiveItem.includes(:media_review, { archivable_item: [:author, :images, :videos] }).order("created_at DESC"),
      page_param: :p,
      items: ARCHIVE_ITEMS_PER_PAGE
    )

    respond_to do | format |
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
        ] }
        format.html { redirect_to media_vault_dashboard_path }
      end
      return
    end

    respond_to do |format|
      flash.now[:success] = "Successfully archived your link!"
      # TODO: Turbo-updating the archive items doesn't currently seem to work.
      #       Leaving it alone for now since this is an admin-only function anyway.
      format.turbo_stream do
        @pagy_archive_items, @archive_items = pagy(
          ArchiveItem.includes(:media_review, { archivable_item: [:author, :images, :videos] }).order("created_at DESC"),
          page_param: :p,
          items: ARCHIVE_ITEMS_PER_PAGE
        )
        render turbo_stream: [
          turbo_stream.replace("flash", partial: "layouts/flashes/turbo_flashes", locals: { flash: flash }),
          turbo_stream.replace("modal", partial: "media_vault/archive/add", locals: { render_empty: true }),
          turbo_stream.update(
            "archived_items",
            partial: "media_vault/archive/archive_items",
            locals: { archive_items: @archive_items }
          ),
          # TODO: In addition to none of the Turbo-updating working, updating the paginator fails
          # because the `pagy/nav` partial can't be found despite being directly from the docs:
          # https://ddnexus.github.io/pagy/how-to.html#use-it-in-your-app
          # turbo_stream.update(
          #   "archived_items_pagination",
          #   partial: "pagy/nav",
          #   locals: { pagy: @pagy_archive_items }
          # )
        ]
      end
      format.html { redirect_to media_vault_dashboard_path }
    end
  end

  # Export entire archive of reviewed media to a JSON File
  sig { void }
  def export_archive_data
    send_data ArchiveItem.generate_json_for_export,
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

    ScrapeCallbackJob.perform_later(scrape, parsed_result)

    render plain: "OK", status: 200
  end
end
