# typed: strict
class JobsStatusController < ApplicationController
  require "sidekiq/api"

  # Index function. Makes available an instance variable containing jobs queue details
  sig { void }
  def index
    @scrapes = Scrape.where(fulfilled: false, error: nil)
    @jobs_queue = []

    # return if Sidekiq::Queue.new.size.zero?
    @jobs_queue = Sidekiq::Queue.new.to_a.reverse.each_with_index.map do |job, ind|
      {
        queue_position: ind + 1,
        url: job.item["args"][0]["arguments"][2],
        user: GlobalID::Locator.locate(job.item["args"][0]["arguments"][3]),
        class: job.item["args"][0]["arguments"][1],
        enqueued_at: Time.at(job.item["enqueued_at"])
      }
    end
  end

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

    redirect_back fallback_location: :job_status_index_path
  end

  sig { void }
  def delete_job
    typed_params = TypedParams[ResubmitJobParams].new.extract!(params)
    Scrape.find(typed_params.id)&.destroy!

    flash[:alert] = "Successfully deleted scrape"

    redirect_back fallback_location: :job_status_index_path
  end
end
