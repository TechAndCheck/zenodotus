require "test_helper"

class ScrapeTest < ActiveSupport::TestCase
  include Minitest::Hooks
  include ActiveJob::TestHelper
  include ActionMailer::TestHelper

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

  test "Can enqueue scrape" do
    scrape = Scrape.create!({
      url: "https://www.instagram.com/p/CBcqOkyDDH8/",
      scrape_type: :instagram
    })

    assert_enqueued_jobs 1 do
      scrape.enqueue
    end
  end

  test "can perform scrape" do
    scrape = Scrape.create!({
      url: "https://www.instagram.com/p/CBcqOkyDDH8/",
      scrape_type: :instagram
    })

    result = scrape.perform
    assert result.has_key?("success")
    assert result["success"]
  end

  test "scrape removed works" do
    scrape = Scrape.create!({
      url: "https://www.instagram.com/p/CBcqOkyDDH8/",
      scrape_type: :instagram
    })

    response = [{ "status": "removed" }.stringify_keys] # responses come in with string not symbols so to simulate that this happens
    scrape.fulfill(response)

    assert scrape.fulfilled
    assert scrape.removed
    assert_not scrape.error
  end

  test "scrape errored works" do
    scrape = Scrape.create!({
      url: "https://www.instagram.com/p/CBcqOkyDDH8/",
      scrape_type: :instagram
    })

    response = [{ "status": "error" }.stringify_keys] # responses come in with string not symbols so to simulate that this happens
    scrape.fulfill(response)

    assert scrape.fulfilled
    assert_not scrape.removed
    assert scrape.error
  end

  test "can fulfill scrape" do
    scrape = Scrape.create!({
      url: "https://www.instagram.com/p/CBcqOkyDDH8/",
      scrape_type: :instagram
    })

    FactCheckOrganization.create(name: "realfact_7", url: "https://realfact.com")

    MediaReview.create(
      original_media_link: "https://www.instagram.com/p/CBcqOkyDDH8/",
      date_published: "2021-02-03",
      url: "https://www.realfact.com/factchecks/2021/feb/03/starwars_7",
      author: {
        "@type": "Organization",
        "name": "realfact_7",
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

    zorki_image_post = InstagramMediaSource.extract("https://www.instagram.com/p/CBcqOkyDDH8/", MediaSource::ScrapeType::Instagram, true)["scrape_result"]
    scrape.fulfill(zorki_image_post)

    assert scrape.fulfilled
  end

  test "can fulfill scrape that's failed" do
    scrape = Scrape.create!({
      url: "https://www.instagram.com/p/not_found/",
      scrape_type: :instagram
    })

    random_number = rand(10000)
    FactCheckOrganization.create!(name: "realfact_#{random_number}", url: "https://www.realfact.com/")

    media_review = MediaReview.create!(
      media_url: "https://www.instagram.com/p/not_found/",
      original_media_link: "https://www.instagram.com/p/not_found/",
      date_published: "2021-02-03",
      url: "https://www.realfact.com/factchecks/2021/feb/03/starwars_57",
      author: {
        "@type": "Organization",
        "name": "realfact_#{random_number}",
        "url": "https://www.realfact.com"
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
        },
        "contentUrl": "https://www.instagram.com/p/not_found/"
      },
      archive_item: archive_items[0]
    )

    zorki_image_post = InstagramMediaSource.extract("https://www.instagram.com/p/not_found/", MediaSource::ScrapeType::Instagram, true)["scrape_result"]

    scrape.fulfill(zorki_image_post)
    media_review.reload

    assert scrape.fulfilled
    assert scrape.removed
    assert media_review.taken_down
  end

  test "scrape created with media review saves it" do
    random_number = rand(10000)
    FactCheckOrganization.create!(name: "realfact_#{random_number}", url: "https://www.realfact.com/")

    mr = MediaReview.create!(
      media_url: "https://www.instagram.com/p/not_found/",
      original_media_link: "https://www.instagram.com/p/not_found/",
      date_published: "2021-02-03",
      url: "https://www.realfact.com/factchecks/2021/feb/03/starwars_57",
      author: {
        "@type": "Organization",
        "name": "realfact_#{random_number}",
        "url": "https://www.realfact.com"
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
        },
        "contentUrl": "https://www.instagram.com/p/not_found/"
      },
      archive_item: archive_items[0]
    )

    scrape = Scrape.create!({
      url: "https://www.instagram.com/p/not_found/",
      scrape_type: :instagram,
      media_review: mr
    })

    assert_not_nil scrape.media_review
  end

  test "fulfilling a scrape creates an archive item with the properly set posted_id" do
    scrape = Scrape.create!({
      url: "https://www.instagram.com/p/CBcqOkyDDH8/",
      scrape_type: :instagram
    })

    FactCheckOrganization.create(name: "realfact_7", url: "https://realfact.com")

    MediaReview.create(
      original_media_link: "https://www.instagram.com/p/CBcqOkyDDH8/",
      date_published: "2021-02-03",
      url: "https://www.realfact.com/factchecks/2021/feb/03/starwars_7",
      author: {
        "@type": "Organization",
        "name": "realfact_7",
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

    zorki_image_post = InstagramMediaSource.extract("https://www.instagram.com/p/CBcqOkyDDH8/", MediaSource::ScrapeType::Instagram, true)["scrape_result"]
    scrape.fulfill(zorki_image_post)

    assert_not_nil scrape.archive_item.posted_at
    assert_equal scrape.archive_item.posted_at, scrape.archive_item.archivable_item.posted_at

    assert_nil scrape.archive_item.submitter
    assert_not scrape.archive_item.private
  end

  test "fulfilling a scrape with a user creates an archive item set to private and with the user on it" do
    scrape = Scrape.create!({
      url: "https://www.instagram.com/p/CBcqOkyDDH8/",
      scrape_type: :instagram,
      user: users(:user)
    })

    FactCheckOrganization.create(name: "realfact_7", url: "https://realfact.com")

    MediaReview.create(
      original_media_link: "https://www.instagram.com/p/CBcqOkyDDH8/",
      date_published: "2021-02-03",
      url: "https://www.realfact.com/factchecks/2021/feb/03/starwars_7",
      author: {
        "@type": "Organization",
        "name": "realfact_7",
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

    zorki_image_post = InstagramMediaSource.extract("https://www.instagram.com/p/CBcqOkyDDH8/", MediaSource::ScrapeType::Instagram, true)["scrape_result"]
    scrape.fulfill(zorki_image_post)

    assert_not_nil scrape.archive_item.posted_at
    assert_equal scrape.archive_item.posted_at, scrape.archive_item.archivable_item.posted_at

    assert_equal scrape.archive_item.submitter, scrape.user
    assert scrape.archive_item.private
  end

  test "emails are sent when a scrape is fulfilled for a MyVault" do
    scrape = Scrape.create!({
      url: "https://www.instagram.com/p/CBcqOkyDDH8/",
      scrape_type: :instagram,
      user: users(:user)
    })

    FactCheckOrganization.create(name: "realfact_7", url: "https://realfact.com")

    MediaReview.create(
      original_media_link: "https://www.instagram.com/p/CBcqOkyDDH8/",
      date_published: "2021-02-03",
      url: "https://www.realfact.com/factchecks/2021/feb/03/starwars_7",
      author: {
        "@type": "Organization",
        "name": "realfact_7",
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

    zorki_image_post = InstagramMediaSource.extract("https://www.instagram.com/p/CBcqOkyDDH8/", MediaSource::ScrapeType::Instagram, true)["scrape_result"]

    assert_emails 1 do
      perform_enqueued_jobs do
        scrape.fulfill(zorki_image_post)
      end
    end
  end

  test "emails are sent when a scrape is removed for a MyVault" do
    scrape = Scrape.create!({
      url: "https://www.instagram.com/p/CBcqOkyDDH8/",
      scrape_type: :instagram,
      user: users(:user)
    })

    response = [{ "status": "removed" }.stringify_keys] # responses come in with string not symbols so to simulate that this happens

    assert_emails 1 do
      perform_enqueued_jobs do
        scrape.fulfill(response)
      end
    end
  end

  test "emails are sent when a scrape errors for a MyVault" do
    scrape = Scrape.create!({
      url: "https://www.instagram.com/p/CBcqOkyDDH8/",
      scrape_type: :instagram,
      user: users(:user)
    })

    response = [{ "status": "error" }.stringify_keys] # responses come in with string not symbols so to simulate that this happens
    assert_emails 1 do
      perform_enqueued_jobs do
        scrape.fulfill(response)
      end
    end
  end


  test "emails are not sent when a scrape is fulfilled for a MyVault without a user" do
    scrape = Scrape.create!({
      url: "https://www.instagram.com/p/CBcqOkyDDH8/",
      scrape_type: :instagram,
    })

    FactCheckOrganization.create(name: "realfact_7", url: "https://realfact.com")

    MediaReview.create(
      original_media_link: "https://www.instagram.com/p/CBcqOkyDDH8/",
      date_published: "2021-02-03",
      url: "https://www.realfact.com/factchecks/2021/feb/03/starwars_7",
      author: {
        "@type": "Organization",
        "name": "realfact_7",
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

    zorki_image_post = InstagramMediaSource.extract("https://www.instagram.com/p/CBcqOkyDDH8/", MediaSource::ScrapeType::Instagram, true)["scrape_result"]

    assert_emails 0 do
      perform_enqueued_jobs do
        scrape.fulfill(zorki_image_post)
      end
    end
  end

  test "emails are not sent when a scrape is removed for a MyVault without a user" do
    scrape = Scrape.create!({
      url: "https://www.instagram.com/p/CBcqOkyDDH8/",
      scrape_type: :instagram,
      user: users(:user)
    })

    response = [{ "status": "removed" }.stringify_keys] # responses come in with string not symbols so to simulate that this happens

    assert_emails 1 do
      perform_enqueued_jobs do
        scrape.fulfill(response)
      end
    end
  end

  test "emails are not sent when a scrape errors for a MyVault without a user" do
    scrape = Scrape.create!({
      url: "https://www.instagram.com/p/CBcqOkyDDH8/",
      scrape_type: :instagram,
      user: users(:user)
    })

    response = [{ "status": "error" }.stringify_keys] # responses come in with string not symbols so to simulate that this happens
    assert_emails 1 do
      perform_enqueued_jobs do
        scrape.fulfill(response)
      end
    end
  end
end
