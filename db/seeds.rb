# typed: strict

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require_relative "../test/mocks/hypatia_mock"
require_relative "../test/mocks/aws_s3_mock"
include HypatiaMock  # Draw seed data from our Hypatia mock
include AwsS3Mock

# Use our test s3 mock to override AwsS3Downloader (ensures db:seed task can operate fully offline)
module S3OverRide
  def download_file_in_s3_received_from_hypatia(url)
    AwsS3Mock.download_file_in_s3_received_from_hypatia(url)
  end
end
AwsS3Downloader.singleton_class.prepend(S3OverRide)

Role.create!([
  { name: "new_user" },
  { name: "insights_user" },
  { name: "media_vault_user" },
  { name: "admin" },
])

easy_password = "password123"

# Super-admin account; no applicant necessary.
admin = User.create!({
  name: "Admin",
  email: "admin@example.com",
  password: easy_password,
  confirmed_at: Time.now,
})
admin.add_role :admin

Applicant.create!([
  # This applicant is a fresh, unconfirmed applicant.
  {
    name: "Jane Doe (Unconfirmed Applicant)",
    email: "unconfirmed-applicant@example.com",
    use_case: "Journalism",
    accepted_terms: true,
    confirmation_token: Devise.friendly_token,
    source_site: SiteDefinitions::FACT_CHECK_INSIGHTS[:shortname],
  },
  # This applicant is confirmed, but not yet reviewed.
  {
    name: "Jane Doe (Unreviewed Applicant)",
    email: "unreviewed-applicant@example.com",
    use_case: "Journalism",
    accepted_terms: true,
    confirmation_token: Devise.friendly_token,
    confirmed_at: Time.now,
    source_site: SiteDefinitions::FACT_CHECK_INSIGHTS[:shortname],
  },
  # This applicant is rejected.
  {
    name: "Jane Doe (Rejected Applicant)",
    email: "rejected-applicant@example.com",
    use_case: "Journalism",
    accepted_terms: true,
    confirmation_token: Devise.friendly_token,
    confirmed_at: Time.now,
    source_site: SiteDefinitions::FACT_CHECK_INSIGHTS[:shortname],
    status: "rejected",
    reviewed_at: Time.now,
    reviewer: admin,
  },
  # This applicant is approved, but hasn't yet been converted to a user.
  {
    name: "Jane Doe (Approved Applicant)",
    email: "approved-applicant@example.com",
    use_case: "Journalism",
    accepted_terms: true,
    confirmation_token: Devise.friendly_token,
    confirmed_at: Time.now,
    source_site: SiteDefinitions::FACT_CHECK_INSIGHTS[:shortname],
    status: "approved",
    reviewed_at: Time.now,
    reviewer: admin,
  },
  # This applicant is approved and will be converted to a standard Insights user.
  {
    name: "Jane Doe (Insights User)",
    email: "insights@example.com",
    use_case: "Journalism",
    accepted_terms: true,
    confirmation_token: Devise.friendly_token,
    confirmed_at: Time.now,
    source_site: SiteDefinitions::FACT_CHECK_INSIGHTS[:shortname],
    status: "approved",
    reviewed_at: Time.now,
    reviewer: admin,
  },
  # This applicant is approved and will be converted to a standard Vault user.
  {
    name: "Jane Doe (Vault User)",
    email: "vault@example.com",
    use_case: "Journalism",
    accepted_terms: true,
    confirmation_token: Devise.friendly_token,
    confirmed_at: Time.now,
    source_site: SiteDefinitions::MEDIA_VAULT[:shortname],
    status: "approved",
    reviewed_at: Time.now,
    reviewer: admin,
  },
])

# Create the standard Insights user (has completed setup and signed in)
insights_user = User.create_from_applicant(Applicant.find_by(email: "insights@example.com"))
insights_user.update!({
  # Override the randomized initial password.
  password: easy_password,
  password_confirmation: easy_password,
})

# Create the standard Vault user (has completed setup and signed in)
vault_user = User.create_from_applicant(Applicant.find_by(email: "vault@example.com"))
vault_user.update!({
  # Override the randomized initial password.
  password: easy_password,
  password_confirmation: easy_password,
})

Sources::Tweet.create_from_url! "https://twitter.com/hamandcheese/status/1574789849403592710"
Sources::Tweet.create_from_url! "https://twitter.com/leahstokes/status/1414669810739281920"
Sources::Tweet.create_from_url! "https://twitter.com/NASA/status/1579902808970649600"

archive_items = ArchiveItem.all

media_review = MediaReview.create(
  original_media_link: "https://www.foobar.com/1",
  date_published: "2021-02-03",
  url: "https://www.realfact.com/factchecks/2021/feb/03/starwars",
  author: {
    "@type": "Organization",
    "name": "realfact",
    "url": "https://realfact.com",
    "image": "https://i.kym-cdn.com/photos/images/newsfeed/001/207/210/b22.jpg",
    "sameAs": "https://twitter.com/realfact"
  },
  media_authenticity_category: "TransformedContent",
  original_media_context_description: "Star Wars Ipsum",
  item_reviewed: {
    "@type": "MediaReviewItem",
    "creator": {
      "@type": "Person",
      "name": "Old Ben-Kenobi",
      "url": "https://www.foobar.com/x/1"
    },
    "interpretedAsClaim": {
      "@type": "Claim",
      "description": "Two droids on the imperial watchlist entered a hovercraft"
    },
    "embeddedTextCaption": "Your droids. They’ll have to wait outside. We don’t want them here. Listen, why don’t you wait out by the speeder. We don’t want any trouble.",
    "mediaItemAppearance": [
      {
        "@type": "ImageObjectSnapshot",
        "description": "A stormtrooper posted a screenshot of two droids entering a hovercraft",
        "sha256sum": ["8bb6caeb301b85cddc7b67745a635bcda939d17044d9bcf31158ef5e9f8ff072"],
        "accessedOnUrl": "https://www.facebook.com/photo.php?fbid=10217541425752089&set=a.1391489831857&type=3",
        "archivedAt": "https://archive.is/dfype"
      },
      {
        "@type": "ImageObjectSnapshot",
        "contentUrl": "https://www.foobar.com/1",
        "archivedAt": "www.archive.org"
      }
    ]
  },
  archive_item: archive_items[0]
)

MediaReview.create(
  original_media_link: "https://www.foobar.com/2",
  date_published: "2021-02-03",
  url: "https://www.realfact.com/factchecks/2021/feb/05/batman",
  author: {
    "@type": "Organization",
    "name": "realfact",
    "url": "https://realfact.com"
  },
  media_authenticity_category: "TransformedContent",
  original_media_context_description: "Batman Ipsum",
  item_reviewed: {
    "@type": "MediaReviewItem",
    "creator": {
      "@type": "Person",
      "name": "Name Nameson",
      "url": "https://user2.com/"
    },
    "embeddedTextCaption": "But we’ve met before. That was a long time ago, I was a kid at St. Swithin’s, It used to be funded by the Wayne Foundation",
    "interpretedAsClaim": {
      "@type": "Claim",
      "description": "Something something batman"
    },
    "mediaItemAppearance": [
      {
      "@type": "VideoObjectSnapshot",
      "description": "A description of a video snapshot"
      },
      {
      "@type": "VideoObjectSnapshot",
      "contentUrl": "https://wwww.foobar.com/2",
      "archivedAt": "https://archive.is/12345"
      }
    ]
  },
  archive_item: archive_items[1]
)

MediaReview.create(
  original_media_link: "https://www.foobar.com/1",
  date_published: "2021-02-03",
  url: "https://www.realfact.com/factchecks/2021/feb/06/back_to_the_future",
  author: {
    "@type": "Organization",
    "name": "realfact",
    "url": "https://realfact.com"
  },
  original_media_context_description: "Back to the Future Ipsum",
  media_authenticity_category: "TransformedContent",
  item_reviewed: {
    "@type": "MediaReviewItem",
    "creator": {
      "@type": "Person",
      "name": "User",
      "url": "https://user.com/"
    },
    "interpretedAsClaim": {
      "@type": "Claim",
      "description": "claim description"
    },
    "embeddedTextCaption": "When could weathermen predict the weather, let alone the future. Yeah, alright, bye-bye.",
    "mediaItemAppearance": [
      {
        "@type": "ImageObjectSnapshot",
        "sha256sum": ["8bb6caeb301b85cddc7b67745a635bcda939d17044d9bcf31158ef5e9f8ff072"],
        "accessedOnUrl": "https://www.facebook.com/photo.php?fbid=10217541425752089&set=a.1391489831857&type=3",
        "archivedAt": "https://archive.is/dfype"
      },
      {
      "@type": "ImageObjectSnapshot",
      "contentUrl": "https://wwww.foobar.com/3",
      "archivedAt": "https://archive.is/145"
      }
    ]
  },
  archive_item: archive_items[2]
)
ClaimReview.create(
  author: {
    "@type": "Organization",
    "name": "realfact",
    "url": "https://www.realfact.com/"
  },
  claim_reviewed: "The approach will not be easy. You are required to maneuver straight down this trench and skim the surface to this point. The target area is only two meters wide.",
  date_published: "2021-02-01",
  item_reviewed: {
    "@type": "Claim",
    "datePublished": "2021-01-30",
    "name": "Star Wars claim",
    "author": {
      "@type": "Person",
      "jobTitle": "On the internet",
      "name": "Viral image"
    },
  },
  review_rating: {
    "@type": "Rating",
    "ratingValue": "4",
    "bestRating": "5",
    "image": "https://static.politifact.com/politifact/rulings/meter-false.jpg",
    "alternateName": "False"
  },
  url: "https://www.realfact.com/factchecks/2021/feb/03/starwars",
  media_review: media_review
)
