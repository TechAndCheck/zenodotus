# typed: strict

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

easy_password = "password123"

# Super-admin account; no applicant necessary.
User.create!({
  email: "admin@example.com",
  password: easy_password,
  super_admin: true,
  confirmed_at: Time.now,
})

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
  # This applicant is approved and has been converted to a restricted user.
  {
    name: "Jane Doe (Restricted User)",
    email: "restricted-user@example.com",
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
  # Make sure they don't look fresh.
  sign_in_count: 1,
})

# Create the restricted user
restricted_user = User.create_from_applicant(Applicant.find_by(email: "restricted-user@example.com"))
restricted_user.update!({
  restricted: true,
  # Override the randomized initial password.
  password: easy_password,
  password_confirmation: easy_password,
  # Make sure they don't look fresh.
  sign_in_count: 1,
})

Sources::Tweet.create_from_url "https://twitter.com/kairyssdal/status/1415029747826905090"
Sources::Tweet.create_from_url "https://twitter.com/leahstokes/status/1414669810739281920"
Sources::Tweet.create_from_url "https://twitter.com/dissectpodcast/status/1409323315735384064"

archive_items = ArchiveItem.all

MediaReview.create(original_media_link: "https://twitter.com/kairyssdal/status/1415029747826905090",
                   media_authenticity_category: "real fake",
                   original_media_context_description: "not too much context",
                   archive_item_id: archive_items[0].id)


MediaReview.create(original_media_link: "https://twitter.com/leahstokes/status/1414669810739281920",
                   media_authenticity_category: "Seems legit",
                   original_media_context_description: "This is an image and that's the context",
                   archive_item_id: archive_items[1].id)

MediaReview.create(original_media_link: "https://twitter.com/dissectpodcast/status/1409323315735384064",
                   media_authenticity_category: "Might be real or fake",
                   original_media_context_description: "Image is warped",
                   archive_item_id: archive_items[2].id)
