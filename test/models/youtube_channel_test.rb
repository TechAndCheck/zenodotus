# typed: ignore
require "test_helper"

class YoutubeChannelTest < ActiveSupport::TestCase
  @@youtube_archiver_channel = nil
  def setup
    @@youtube_archiver_channel = YoutubeMediaSource.extract("https://www.youtube.com/watch?v=kFFvomxcLWo", true)["scrape_result"].first["post"]["channel"] if @@youtube_archiver_channel.nil?
  end

  def teardown
    if File.exist?("tmp/youtube_archiver") && File.directory?("tmp/youtube_archiver")
      FileUtils.rm_r "tmp/youtube_archiver"
    end
  end

  test "can create youtube channel" do
    archive_entity = Sources::YoutubeChannel.create_from_youtube_archiver_hash([@@youtube_archiver_channel]).first
    assert_not_nil archive_entity
    assert_kind_of ArchiveEntity, archive_entity

    assert_equal @@youtube_archiver_channel["title"], archive_entity.youtube_channel.title
    assert_equal @@youtube_archiver_channel["description"], archive_entity.youtube_channel.description
    assert_equal @@youtube_archiver_channel["id"], archive_entity.service_id

    assert_equal @@youtube_archiver_channel["view_count"].to_i, archive_entity.youtube_channel.num_views
    assert_equal @@youtube_archiver_channel["subscriber_count"].to_i, archive_entity.youtube_channel.num_subscribers
    assert_equal @@youtube_archiver_channel["video_count"].to_i, archive_entity.youtube_channel.num_videos

    assert_not_nil archive_entity.youtube_channel.channel_image
  end

  test "can update youtube channel" do
    archive_entity = Sources::YoutubeChannel.create_from_youtube_archiver_hash([@@youtube_archiver_channel]).first

    # Set a property to something random
    archive_entity.youtube_channel.update!({ num_subscribers: 2 })
    assert_equal archive_entity.youtube_channel.num_subscribers, 2
    # Now try and save it again, and make sure the subscriber count is correct
    archive_entity2 = Sources::YoutubeChannel.create_from_youtube_archiver_hash([@@youtube_archiver_channel]).first
    assert_equal archive_entity.service_id, archive_entity2.service_id
    assert_equal @@youtube_archiver_channel["subscriber_count"].to_i, archive_entity2.youtube_channel.num_subscribers
  end
end
