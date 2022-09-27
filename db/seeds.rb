# typed: strict

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Role.create!([
  { name: "new_user" },
  { name: "insights_user" },
  { name: "media_vault_user" },
  { name: "admin" },
])

easy_password = "password123"

# Super-admin account; no applicant necessary.
admin = User.create!({
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
  },
  # This applicant is confirmed, but not yet reviewed.
  {
    name: "Jane Doe (Unreviewed Applicant)",
    email: "unreviewed-applicant@example.com",
    use_case: "Journalism",
    accepted_terms: true,
    confirmation_token: Devise.friendly_token,
    confirmed_at: Time.now,
  },
  # This applicant is rejected.
  {
    name: "Jane Doe (Rejected Applicant)",
    email: "rejected-applicant@example.com",
    use_case: "Journalism",
    accepted_terms: true,
    confirmation_token: Devise.friendly_token,
    confirmed_at: Time.now,
    status: "rejected",
  },
  # This applicant is approved, but hasn't yet been converted to a user.
  {
    name: "Jane Doe (Approved Applicant)",
    email: "approved-applicant@example.com",
    use_case: "Journalism",
    accepted_terms: true,
    confirmation_token: Devise.friendly_token,
    confirmed_at: Time.now,
    status: "approved",
  },
  # This applicant is approved and has been converted to a standard user.
  {
    name: "Jane Doe (Standard User)",
    email: "user@example.com",
    use_case: "Journalism",
    accepted_terms: true,
    confirmation_token: Devise.friendly_token,
    confirmed_at: Time.now,
    status: "approved",
  },
])

# Create the standard user (has completed setup and signed in)
standard_user = User.create_from_applicant(Applicant.find_by(email: "user@example.com"))
standard_user.update!({
  # Override the randomized initial password.
  password: easy_password,
  password_confirmation: easy_password,
})

Sources::Tweet.create_from_url "https://twitter.com/hamandcheese/status/1574789849403592710"
Sources::Tweet.create_from_url "https://twitter.com/leahstokes/status/1414669810739281920"
Sources::Tweet.create_from_url "https://twitter.com/dissectpodcast/status/1409323315735384064"

archive_items = ArchiveItem.all

media_review = MediaReview.create(
  original_media_link: "https://www.foobar.com/1",
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
  original_media_context_description: "Star Wars Ipsum",
  item_reviewed: {
    "@type": "MediaReviewItem",
    "embeddedTextCaption": "But we’ve met before. That was a long time ago, I was a kid at St. Swithin’s, It used to be funded by the Wayne Foundation",
    "originalMediaLink": "https://www.foobar.com/2",
    "appearance": {
      "@type": "ImageObjectSnapshot",
      "sha256sum": ["8bb6caeb301b85cddc7b67745a635bcda939d17044d9bcf31158ef5e9f8ff072"],
      "accessedOnUrl": "https://www.facebook.com/photo.php?fbid=10217541425752089&set=a.1391489831857&type=3",
      "archivedAt": "https://archive.is/dfype"
    }
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
  original_media_context_description: "Star Wars Ipsum",
  media_authenticity_category: "TransformedContent",
  item_reviewed: {
    "@type": "MediaReviewItem",
    "embeddedTextCaption": "When could weathermen predict the weather, let alone the future. Yeah, alright, bye-bye.",
    "originalMediaLink": "https://www.foobar.com/3",
    "appearance": {
      "@type": "ImageObjectSnapshot",
      "sha256sum": ["8bb6caeb301b85cddc7b67745a635bcda939d17044d9bcf31158ef5e9f8ff072"],
      "accessedOnUrl": "https://www.facebook.com/photo.php?fbid=10217541425752089&set=a.1391489831857&type=3",
      "archivedAt": "https://archive.is/dfype"
    }
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
    "author": {
      "@type": "Person",
      "jobTitle": "On the internet",
      "name": "Viral image"
    },
    "datePublished": "2021-01-30"
  },
  review_rating: {
    "@type": "Rating",
    "alternateName": "False",
    "bestRating": "9",
    "ratingValue": "4",
    "worstRating": "0"
  },
  url: "https://www.realfact.com/factchecks/2021/feb/03/starwars",
  media_review: media_review
)
