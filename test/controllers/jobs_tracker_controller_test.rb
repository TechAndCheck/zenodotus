require "test_helper"

class JobsTrackerControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "can view jobs" do
    sign_in users(:user1)
    InstagramMediaSource.extract("https://www.instagram.com/p/CBcqOkyDDH8/?utm_source=ig_embed", false)
    get jobs_status_index_path
    assert_response :success
  end

  test "can resubmit a scrape" do
    sign_in users(:user1)
    scrape = Scrape.create({ fulfilled: false, url: "https://www.instagram.com/p/CBcqOkyDDH8/?utm_source=ig_embed", scrape_type: :instagram })
    assert_not_nil scrape

    assert_enqueued_jobs 0

    post job_status_resubmit_path(id: scrape.id)
    scrape.reload
    assert scrape.error

    assert_enqueued_jobs 1
  end

  test "can delete a scrape" do
    sign_in users(:user1)
    scrape = Scrape.create({ fulfilled: false, url: "https://www.instagram.com/p/CBcqOkyDDH8/?utm_source=ig_embed", scrape_type: :instagram })
    assert_not_nil scrape

    delete job_status_delete_path(id: scrape.id)
    assert_raises ActiveRecord::RecordNotFound do
      Scrape.find(scrape.id)
    end
  end
end
