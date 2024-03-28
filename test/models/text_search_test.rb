require "test_helper"

class TextSearchTest < ActiveSupport::TestCase
  include Devise::Test::IntegrationHelpers
  include Minitest::Hooks

  def around
    AwsS3Downloader.stub(:download_file_in_s3_received_from_hypatia, S3_MOCK_STUB) do
      super
    end
  end

  def after_all
    if File.exist?("tmp") && File.directory?("tmp")
      FileUtils.rm_r("tmp")
    end
  end

  def setup
    @text_search = TextSearch.create(query: "Biden")

    # Set up a public archived post
    @public_scrape = Scrape.create!({
      url: "https://www.instagram.com/p/CHdIkUVBz3C",
      scrape_type: :instagram,
    })

    zorki_image_post = InstagramMediaSource.extract("https://www.instagram.com/p/CHdIkUVBz3C/", MediaSource::ScrapeType::Instagram, true)["scrape_result"]

    @public_scrape.fulfill(zorki_image_post)

    # Set up a private archived post
    @private_scrape = Scrape.create!({
      url: "https://www.instagram.com/p/CHdIkUVBz3C",
      scrape_type: :instagram,
      user: users(:user),
    })

    zorki_image_post = InstagramMediaSource.extract("https://www.instagram.com/p/CHdIkUVBz3C/", MediaSource::ScrapeType::Instagram, true)["scrape_result"]
    @private_scrape.fulfill(zorki_image_post)
  end

  test "can create text search" do
    assert_not_nil @text_search
    assert_not_nil @text_search.query
  end

  test "can create text search with user" do
    text_search = TextSearch.create(query: "Biden", user: users(:user))
    assert_not_nil text_search
  end

  test "can create private text search with user" do
    sign_in users(:user)
    text_search = TextSearch.create(query: "Biden", user: users(:user), private: true)
    assert_not_nil text_search
  end

  test "public text search returns public results" do
    text_search = TextSearch.create(query: "pardoned", private: false)
    results = text_search.run
    assert_predicate results, :any?
    assert_equal @public_scrape.archive_item.archivable_item, results.first
    assert_not_equal @private_scrape.archive_item.archivable_item, results.first
  end

  test "private text search returns private results and not public results" do
    text_search = TextSearch.create(query: "pardoned", user: users(:user), private: true)
    results = text_search.run
    assert_predicate results, :any?
    assert_equal @private_scrape.archive_item.archivable_item, results.first
    assert_not_equal @public_scrape.archive_item.archivable_item, results.first
  end
end
