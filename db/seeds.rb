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
