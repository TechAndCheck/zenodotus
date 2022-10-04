# Preview all emails at http://localhost:3000/rails/mailers/account_mailer
class AccountMailerPreview < ActionMailer::Preview
  def setup_email
    AccountMailer.with(
      user: {
        email: "applicant@example.com",
      },
      token: "abc123",
      site: SiteDefinitions::FACT_CHECK_INSIGHTS,
    ).setup_email
  end
end
