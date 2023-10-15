require "test_helper"

class Admin::JobsStatusControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "can view jobs" do
    sign_in users(:admin)

    get admin_jobs_status_root_path
    assert_response :success
  end

  test "cannot view jobs as a non-admin user" do
    sign_in users(:user)

    get admin_jobs_status_root_path
    assert_response :redirect
    assert_equal "You don’t have permission to access that page.", flash[:error]
  end

  test "can resubmit a scrape" do
    sign_in users(:admin)
    scrape = Scrape.create({ fulfilled: false, url: "https://www.instagram.com/p/CBcqOkyDDH8/", scrape_type: MediaSource::ScrapeType::Instagram.serialize })
    assert_not_nil scrape

    assert_enqueued_jobs 0

    post admin_jobs_status_resubmit_path(id: scrape.id)
    scrape.reload
    assert scrape.error

    assert_enqueued_jobs 1
  end

  test "can delete a scrape" do
    sign_in users(:admin)
    scrape = Scrape.create({ fulfilled: false, url: "https://www.instagram.com/p/CBcqOkyDDH8/", scrape_type: MediaSource::ScrapeType::Instagram.serialize })
    assert_not_nil scrape

    delete admin_jobs_status_delete_path(id: scrape.id)
    assert_raises ActiveRecord::RecordNotFound do
      Scrape.find(scrape.id)
    end
  end
end
