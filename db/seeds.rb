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
