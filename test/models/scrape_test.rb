require "test_helper"

class ScrapeTest < ActiveSupport::TestCase
  include Minitest::Hooks
  include ActiveJob::TestHelper

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


  test "can create scrape" do
    assert_not_nil Scrape.create!({
      url: "https://www.instagram.com/p/Cgu8NH6usai/?utm_source=ig_web_copy_link",
      scrape_type: :instagram
    })
  end

  test "can fulfill scrape" do
    scrape = Scrape.create!({
      url: "https://www.instagram.com/p/CBcqOkyDDH8/",
      scrape_type: :instagram
    })

    MediaReview.create(
      original_media_link: "https://www.instagram.com/p/CBcqOkyDDH8/",
      date_published: "2021-02-03",
      url: "https://www.realfact.com/factchecks/2021/feb/03/starwars",
      author: {
        "@type": "Organization",
        "name": "realfact",
        "url": "https://realfact.com"
      },
      media_authenticity_category: "TransformedContent",
      original_media_context_description: "Star Wars Ipsum",
      item_reviewed: {
        "@type": "MediaReviewItem",
        "embeddedTextCaption": "Your droids. They’ll have to wait outside. We don’t want them here. Listen, why don’t you wait out by the speeder. We don’t want any trouble.",
        "originalMediaLink": "https://www.foobar.com/1",
        "appearance": {
          "@type": "ImageObjectSnapshot",
          "sha256sum": ["8bb6caeb301b85cddc7b67745a635bcda939d17044d9bcf31158ef5e9f8ff072"],
          "accessedOnUrl": "https://www.facebook.com/photo.php?fbid=10217541425752089&set=a.1391489831857&type=3",
          "archivedAt": "https://archive.is/dfype"
        }
      },
      archive_item: archive_items[0]
    )

    zorki_image_post = InstagramMediaSource.extract("https://www.instagram.com/p/CBcqOkyDDH8/", true)["scrape_result"]

    scrape.fulfill(zorki_image_post)

    assert scrape.fulfilled
  end

  test "can fulfill scrape that's failed" do
    scrape = Scrape.create!({
      url: "https://www.instagram.com/p/not_found/",
      scrape_type: :instagram
    })

    media_review = MediaReview.create(
      original_media_link: "https://www.instagram.com/p/not_found/",
      date_published: "2021-02-03",
      url: "https://www.realfact.com/factchecks/2021/feb/03/starwars",
      author: {
        "@type": "Organization",
        "name": "realfact",
        "url": "https://realfact.com"
      },
      media_authenticity_category: "TransformedContent",
      original_media_context_description: "Star Wars Ipsum",
      item_reviewed: {
        "@type": "MediaReviewItem",
        "embeddedTextCaption": "Your droids. They’ll have to wait outside. We don’t want them here. Listen, why don’t you wait out by the speeder. We don’t want any trouble.",
        "originalMediaLink": "https://www.foobar.com/1",
        "appearance": {
          "@type": "ImageObjectSnapshot",
          "sha256sum": ["8bb6caeb301b85cddc7b67745a635bcda939d17044d9bcf31158ef5e9f8ff072"],
          "accessedOnUrl": "https://www.facebook.com/photo.php?fbid=10217541425752089&set=a.1391489831857&type=3",
          "archivedAt": "https://archive.is/dfype"
        }
      },
      archive_item: archive_items[0]
    )

    zorki_image_post = InstagramMediaSource.extract("https://www.instagram.com/p/not_found/", true)["scrape_result"]

    scrape.fulfill(zorki_image_post)
    media_review.reload

    assert scrape.fulfilled
    assert scrape.removed
    assert media_review.taken_down
  end
end
