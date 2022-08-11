# typed: strict

class JobsStatusController < ApplicationController
  require "sidekiq/api"

  RESULTS_PER_PAGE = 10

  # A class representing the allowed params into the `search` endpoint
  class JobsParams < T::Struct
    const :active_scrapes_page, T.nilable(String)
  end

  # Index function. Makes available an instance variable containing jobs queue details
  sig { void }
  def index
    typed_params = TypedParams[JobsParams].new.extract!(params)

    scrapes_for_page_number(typed_params.active_scrapes_page) # set the variables for scrapes
    jobs_count # set the variables for jobs
  end

  sig { void }
  def scrapes
    typed_params = TypedParams[JobsParams].new.extract!(params)

    scrapes_for_page_number(typed_params.active_scrapes_page) # set the variables for scrapes
    render partial: "jobs_status/scrapes", layout: false
  end

  sig { void }
  def active_jobs
    jobs_count # set the variables for scrapes
    render partial: "jobs_status/active_jobs", layout: false
  end

  # A class representing the allowed params into the `submit_url` endpoint
  class ResubmitScrapeParams < T::Struct
    const :id, String
    const :page, T.nilable(String)
  end

  # Resubmits a scrape to Hypatia
  sig { void }
  def resubmit_scrape
    typed_params = TypedParams[ResubmitScrapeParams].new.extract!(params)

    scrape = Scrape.find(typed_params.id)
    scrape.update!({ error: true })

    object_model = ArchiveItem.model_for_url(scrape.url)
    object_model.create_from_url(scrape.url, current_user)
    flash[:alert] = "Successfully resubmitted scrape"

    page = typed_params.page.nil? ? 1 : typed_params.page
    scrapes_for_page_number(page) # Fill the variables for turbo

    ActionCable.server.broadcast("scrapes_channel", { scrapes_count: Scrape.where(fulfilled: false, error: nil).count })

    respond_to do |format|
      format.turbo_stream { render turbo_stream: [
        turbo_stream.replace(:scrapes, partial: "jobs_status/scrapes"),
        turbo_stream.replace("flash", partial: "layouts/flashes/turbo_flashes", locals: { flash: flash })
      ]}
      format.html { redirect_back fallback_location: :jobs_status_index }
    end
  end

  sig { void }
  def delete_scrape
    typed_params = TypedParams[ResubmitScrapeParams].new.extract!(params)
    @scrape = Scrape.find(typed_params.id)
    return if @scrape.nil?

    @scrape.destroy!

    flash[:alert] = "Successfully deleted scrape"

    page = typed_params.page.nil? ? 1 : typed_params.page
    scrapes_for_page_number(page) # Fill the variables for turbo

    ActionCable.server.broadcast("scrapes_channel", { scrapes_count: Scrape.where(fulfilled: false, error: nil).count })

    respond_to do |format|
      format.turbo_stream { render turbo_stream: [
        turbo_stream.replace(:scrapes, partial: "jobs_status/scrapes"),
        turbo_stream.replace("flash", partial: "layouts/flashes/turbo_flashes", locals: { flash: flash })
      ]}
      format.html { redirect_back fallback_location: :jobs_status_index }
    end
  end

private

  def scrapes_for_page_number(page_number)
    @active_scrapes_page = page_number.blank? ? 1 : page_number.to_i

    @scrapes = Scrape.where(fulfilled: false, error: nil).order(created_at: "DESC").limit(RESULTS_PER_PAGE).offset((@active_scrapes_page - 1) * RESULTS_PER_PAGE)
    @total_scrapes_count = Scrape.where(fulfilled: false, error: nil).count

    scrapes_next_page_count = Scrape.where(fulfilled: false, error: nil).limit(RESULTS_PER_PAGE).offset(@active_scrapes_page * RESULTS_PER_PAGE).count
    @previous_scrapes_page = @active_scrapes_page == 1 ? nil : @active_scrapes_page - 1
    @next_scrapes_page = scrapes_next_page_count.zero? ? nil : @active_scrapes_page + 1
  end

  def jobs_count
    @total_jobs_count = Sidekiq::Queue.new.count
  end
end
