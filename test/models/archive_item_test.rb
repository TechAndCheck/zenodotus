# typed: strict

require "test_helper"

class ArchiveItemTest < ActionDispatch::IntegrationTest
  include Minitest::Hooks
  include Devise::Test::IntegrationHelpers

  def around
    AwsS3Downloader.stub(:download_file_in_s3_received_from_hypatia, S3_MOCK_STUB) do
      super
    end
  end

  test "destroying a user resets the submitter_id of ArchiveItems it created" do
    sign_in users(:user)
    Sources::Tweet.create_from_url! "https://twitter.com/jack/status/20", users(:user)
    assert_not_nil ArchiveItem.first.submitter
    User.destroy(users(:user).id)
    assert_nil ArchiveItem.first.submitter
  end

  test "scraping a post creates a screenshot" do
    forki_post = FacebookMediaSource.extract("https://www.facebook.com/Meta/photos/460964425465155", true)["scrape_result"]
    archive_item = Sources::FacebookPost.create_from_forki_hash(forki_post).first
    assert_not_nil archive_item.screenshot
  end

  test "creating an archive item with partially invalid `mediaItemAppearance`s works still" do
    json = {
              "@context": "https://schema.org",
              "@type": " MediaReview",
              "datePublished": "2021-04-27",
              "url": "https://www.politifact.com/factchecks/2021/apr/27/instagram-posts/mariah-carey-didnt-fake-getting-her-covid-19-vacci/",
              "author": {
                "@type": "Organization",
                "name": "PolitiFact",
                "url": "https://politifact.com"
              },
              "mediaAuthenticityCategory": "DecontexualizedContent",
              "originalMediaContextDescription": "Singer Mariah Carey shared a video of herself receiving a COVID-19 vaccination.",
              "itemReviewed": {
                "@type": "MediaReviewItem",
                "creator": {
                  "@type": "Person",
                  "name": "Instagram user",
                  "url": "https://www.instagram.com/wrong_saloon_bear/?hl=en"
                },
                "interpretedAsClaim": {
                  "@type": "Claim",
                  "description": "Mariah Carey faked getting her COVID-19 vaccine because the needle can’t be seen coming out of her arm."
                },
                "mediaItemAppearance": [{
                  "@type": "VideoObjectSnapshot",
                  "description": "An Instagram user posted a zoomed-in version of a video of Mariah Carey receiving a COVID vaccination, writing ‘It’s all a scam, don’t celebrate celebrities.’"
                }, {
                  "@type": "VideoObjectSnapshot",
                  "accessedOnUrl": "https://twitter.com/MariahCarey/status/1438419033267871746",
                  "archivedAt": "https://archive.is/EXAMPLE"
                }]
              }
            }

    archive_item = nil
    assert_nothing_raised do
      archive_item = ArchiveItem.create_from_media_review(json.deep_stringify_keys, nil)
    end
    assert_equal "MediaReview", archive_item.item_reviewed["@type"]
  end

  test "Submitting various URLs returns the correct model type" do
    url = "https://web.facebook.com/shalikarukshan.senadheera/posts/pfbid0287di3uHqt6s8ARUcuY7fNyyP86xEsvg7yjmn9v4eG1QLMrikwAPKvNoDy4Pynjtjl?_rdc=1&_rdr"
    assert_equal Sources::FacebookPost, ArchiveItem.model_for_url(url)

    url = "https://www.facebook.com/100080150081712/posts/209445141737154/?_rdc=2&_rdr"
    assert_equal Sources::FacebookPost, ArchiveItem.model_for_url(url)

    url = "https://www.facebook.com/camnewsday/posts/pfbid0DwJTGtqdquwx1s9jkWvn99kJFNGp6PJYeiLZnoZN7zLxGaVhJKFxSKMjSFt8efBUl"
    assert_equal Sources::FacebookPost, ArchiveItem.model_for_url(url)

    url = "https://mobile.twitter.com/MichelCaballero/status/1637639770347040769"
    assert_equal Sources::Tweet, ArchiveItem.model_for_url(url)
  end
end
