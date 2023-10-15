require "test_helper"

class ImageHashTest < ActiveSupport::TestCase
  include Minitest::Hooks

  def setup
    Zelkova.graph.reset
  end

  def teardown
    Zelkova.graph.reset
  end

  def around
    AwsS3Downloader.stub(:download_file_in_s3_received_from_hypatia, S3_MOCK_STUB) do
      super
    end
  end

  test "dhash properly added to graph" do
    graph_node_count = Zelkova.graph.nodes.count

    birdsong_image_tweet = TwitterMediaSource.extract("https://twitter.com/Bucks/status/1412471909296578563", MediaSource::ScrapeType::Twitter, true)["scrape_result"]
    Sources::Tweet.create_from_birdsong_hash(birdsong_image_tweet).first

    assert Zelkova.graph.nodes.count > graph_node_count
  end
end
