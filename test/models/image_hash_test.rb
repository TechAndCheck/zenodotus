require "test_helper"

class ImageHashTest < ActiveSupport::TestCase
  include Minitest::Hooks

  def setup
    Zelkova.graph.reset
  end

  def teardown
    Zelkova.graph.reset
  end

  test "dhash properly added to graph" do
    graph_node_count = Zelkova.graph.nodes.count

    birdsong_image_tweet = TwitterMediaSource.extract("https://twitter.com/Bucks/status/1412471909296578563")
    Sources::Tweet.create_from_birdsong_hash(birdsong_image_tweet).first

    assert Zelkova.graph.nodes.count > graph_node_count
  end
end
