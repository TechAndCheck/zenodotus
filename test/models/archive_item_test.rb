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
    forki_post = FacebookMediaSource.extract("https://www.facebook.com/Meta/photos/460964425465155", MediaSource::ScrapeType::Facebook, true)["scrape_result"]
    archive_item = Sources::FacebookPost.create_from_forki_hash(forki_post).first
    assert_not_nil archive_item.screenshot
  end

  test "archive items by default only retrieve publicly available items" do
    zorki_image_post = InstagramMediaSource.extract("https://www.instagram.com/p/CBcqOkyDDH8/", MediaSource::ScrapeType::Instagram, true)["scrape_result"]
    Sources::InstagramPost.create_from_zorki_hash(zorki_image_post).first
    assert_equal 1, ArchiveItem.count

    archive_item = ArchiveItem.first
    archive_item.update(private: true)
    assert_equal 0, ArchiveItem.publically_viewable.count
  end

  test "archive items that are private can still be retrieve by user" do
    zorki_image_post = InstagramMediaSource.extract("https://www.instagram.com/p/CBcqOkyDDH8/", MediaSource::ScrapeType::Instagram, true)["scrape_result"]
    archive_item = Sources::InstagramPost.create_from_zorki_hash(zorki_image_post).first
    user = users(:user)
    user.archive_items << archive_item
    assert_equal 1, user.archive_items.count
    archive_item.update(private: true)
    assert_equal 1, user.archive_items.count
  end

  test "archive items that are private can be upgraded to public" do
    zorki_image_post = InstagramMediaSource.extract("https://www.instagram.com/p/CBcqOkyDDH8/", MediaSource::ScrapeType::Instagram, true)["scrape_result"]
    archive_item = Sources::InstagramPost.create_from_zorki_hash(zorki_image_post).first
    archive_item.update private: true

    user = users(:user)
    user.archive_items << archive_item
    assert_equal 1, user.archive_items.count

    assert_equal 0, ArchiveItem.publically_viewable.count
    archive_item.promote_to_public
    assert_equal 1, ArchiveItem.publically_viewable.count
  end

  test "multiple users can be associated with an archive item" do
    zorki_image_post = InstagramMediaSource.extract("https://www.instagram.com/p/CBcqOkyDDH8/", MediaSource::ScrapeType::Instagram, true)["scrape_result"]
    archive_item = Sources::InstagramPost.create_from_zorki_hash(zorki_image_post).first
    user = users(:user)
    user.archive_items << archive_item
    user2 = users(:media_vault_user)
    user2.archive_items << archive_item
    assert_equal 2, archive_item.users.count
  end

  test "an archive item with multiple users isn't deleted if one of the users is" do
    zorki_image_post = InstagramMediaSource.extract("https://www.instagram.com/p/CBcqOkyDDH8/", MediaSource::ScrapeType::Instagram, true)["scrape_result"]
    archive_item = Sources::InstagramPost.create_from_zorki_hash(zorki_image_post).first
    user = users(:user)
    user.archive_items << archive_item
    user2 = users(:media_vault_user)
    user2.archive_items << archive_item
    assert_equal 2, archive_item.users.count

    user.destroy
    assert_equal 1, ArchiveItem.count
  end

  # TODO... this is wrong, it doesn't return an ArchiveItem, it's a MediaReview
  test "creating an archive item with a contentUrl works" do
    FactCheckOrganization.create(name: "Fact Crescendo", url: "https://cambodia.factcrescendo.com/")

    json = {
            "@context": "http://schema.org",
            "@type": "MediaReview",
            "author": {
              "@type": "Organization",
              "name": "Fact Crescendo",
              "url": "https://cambodia.factcrescendo.com/"
            },
            "datePublished": "2023-05-26",
            "itemReviewed": {
              "@type": "ImageObject",
              "contentUrl": "https://www.facebook.com/Cambodiatruenews/posts/pfbid0LsS4mwCSiafVsUjhmSdMRNufyJxmuVpX5nnsLprVxuBSpctmvxrshNXRa3d9jCWMl"
            },
            "mediaAuthenticityCategory": [
              "TransformedContent"
            ],
            "originalMediaContextDescription": "The original photo depicts Cambodian Army Chief Hun Manet \u2013 Prime Minister Hun Sen\u2019s oldest son \u2013 carrying the Cambodian flag and walking in a military parade in early 2019.",
            "originalMediaLink": "https://royalcambodiaarmy.blogspot.com/2019/01/blog-post_23.html",
            "sdPublisher": {
              "@type": "Organization",
              "name": "Google Fact Check Tools",
              "url": "https://g.co/factchecktools"
            },
            "url": "https://cambodia.factcrescendo.com/english/a-photo-of-hun-manet-carrying-the-vietnamese-flag-digitally-edited/"
          }

    archive_item = nil
    assert_nothing_raised do
      archive_item = ArchiveItem.create_from_media_review(json.deep_stringify_keys, nil)
    end

    assert_equal "ImageObject", archive_item.item_reviewed["@type"]
  end

  test "creating an archive item with partially invalid `mediaItemAppearance`s works still" do
    FactCheckOrganization.create(name: "PolitiFact", url: "https://politifact.com")

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
    assert_equal "MediaReviewItem", archive_item.item_reviewed["@type"]
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

    url = "https://www.tiktok.com/@guess/video/7091753416032128299"
    assert_equal Sources::TikTokPost, ArchiveItem.model_for_url(url)
  end

  test "a url is added to the archive item" do
    zorki_image_post = InstagramMediaSource.extract("https://www.instagram.com/p/CBcqOkyDDH8/", MediaSource::ScrapeType::Instagram, true)["scrape_result"]
    archive_item = Sources::InstagramPost.create_from_zorki_hash(zorki_image_post).first
    assert_not_nil archive_item.url
    assert_equal "https://www.instagram.com/p/CBcqOkyDDH8/", archive_item.url
  end

  test "can categorize an archive item" do
    zorki_image_post = InstagramMediaSource.extract("https://www.instagram.com/p/CHdIkUVBz3C/", MediaSource::ScrapeType::Instagram, true)["scrape_result"]
    archive_item = Sources::InstagramPost.create_from_zorki_hash(zorki_image_post).first
    archive_item.categorize!
    assert_equal "Politics", archive_item.categories.first.name
  end

  test "automatically categorized on create" do
    zorki_image_post = InstagramMediaSource.extract("https://www.instagram.com/p/CHdIkUVBz3C/", MediaSource::ScrapeType::Instagram, true)["scrape_result"]
    archive_item = Sources::InstagramPost.create_from_zorki_hash(zorki_image_post).first
    assert_equal "Politics", archive_item.categories.first.name
  end

  test "can remove categories" do
    zorki_image_post = InstagramMediaSource.extract("https://www.instagram.com/p/CHdIkUVBz3C/", MediaSource::ScrapeType::Instagram, true)["scrape_result"]
    archive_item = Sources::InstagramPost.create_from_zorki_hash(zorki_image_post).first
    assert archive_item.categories.count.positive?

    archive_item.clear_categories!
    assert_equal 0, archive_item.categories.count
  end
end
