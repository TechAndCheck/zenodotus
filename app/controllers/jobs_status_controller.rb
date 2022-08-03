# typed: strict

class JobsStatusController < ApplicationController
  require "sidekiq/api"

  # A class representing the allowed params into the `search` endpoint
  class JobsParams < T::Struct
    const :active_scrapes_page, T.nilable(String)
    const :active_jobs_page, T.nilable(String)
  end

  # Index function. Makes available an instance variable containing jobs queue details
  sig { void }
  def index
    typed_params = TypedParams[JobsParams].new.extract!(params)
    results_per_page = 2

    @active_scrapes_page = typed_params.active_scrapes_page.blank? ? 1 : typed_params.active_scrapes_page.to_i
    @active_jobs_page = typed_params.active_jobs_page.blank? ? 1 : typed_params.active_jobs_page.to_i

    @scrapes = Scrape.where(fulfilled: false, error: nil).limit(results_per_page).offset((@active_scrapes_page - 1) * results_per_page)
    @total_scrapes_count = Scrape.where(fulfilled: false, error: nil).count
    @jobs_queue = []

    scrapes_next_page_count = Scrape.where(fulfilled: false, error: nil).limit(results_per_page).offset(@active_scrapes_page * results_per_page).count
    @previous_scrapes_page = @active_scrapes_page == 1 ? nil : @active_scrapes_page - 1
    @next_scrapes_page = scrapes_next_page_count.zero? ? nil : @active_scrapes_page + 1

    # return if Sidekiq::Queue.new.size.zero?
    jobs = Sidekiq::Queue.new.to_a.reverse
    @total_jobs_count = jobs.count

    number_of_jobs_pages = (jobs.count / results_per_page.to_f).ceil

    @jobs_offset = (@active_jobs_page - 1) * results_per_page
    jobs = jobs[@jobs_offset...(@jobs_offset + results_per_page)]
    @previous_jobs_page = @active_jobs_page == 1 ? nil : @active_jobs_page - 1
    @next_jobs_page = @active_jobs_page == number_of_jobs_pages ? nil : @active_jobs_page + 1

    @jobs_queue = jobs.each_with_index.map do |job, ind|
      {
        queue_position: ind + 1,
        url: job.item["args"][0]["arguments"][2],
        user: GlobalID::Locator.locate(job.item["args"][0]["arguments"][3]),
        class: job.item["args"][0]["arguments"][1],
        enqueued_at: Time.at(job.item["enqueued_at"])
      }
    end
  end

  # A class representing the allowed params into the `search` endpoint
  # class NextPageParams < T::Struct
  #   const :page, T.nilable(String)
  # end

  # sig { void }
  # def next_page_scrapes
  #   results_per_page = 2
  #   typed_params = TypedParams[NextPageParams].new.extract!(params)

  #   scrapes = Scrape.where(fulfilled: false, error: nil).limit(results_per_page).offset(typed_params.page * results_per_page)

  #   respond_to do |format|
  #     format.turbo_stream {
  #       render turbo_stream: [
  #         turbo_stream.replace(
  #           "search_results",
  #           partial: "job_status/scrapes",
  #           locals: { scrapes: scrapes }
  #         )
  #       ]
  #     }
  #     format.html { redirect_to :root }
  #   end
  # end

  # A class representing the allowed params into the `submit_url` endpoint
  class ResubmitJobParams < T::Struct
    const :id, String
  end

  # Resubmits a scrape to Hypatia
  sig { void }
  def resubmit_scrape
    typed_params = TypedParams[ResubmitJobParams].new.extract!(params)

    scrape = Scrape.find(typed_params.id)
    scrape.update!({ error: true })

    object_model = ArchiveItem.model_for_url(scrape.url)
    object_model.create_from_url(scrape.url, current_user)
    flash[:alert] = "Successfully resubmitted scrape"

    redirect_back fallback_location: :jobs_status_index
  end

  sig { void }
  def delete_job
    typed_params = TypedParams[ResubmitJobParams].new.extract!(params)
    Scrape.find(typed_params.id)&.destroy!

    flash[:alert] = "Successfully deleted scrape"

    redirect_back fallback_location: :jobs_status_index
  end
end
