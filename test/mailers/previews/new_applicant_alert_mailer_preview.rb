# Preview all emails at http://localhost:3000/rails/mailers/new_applicant_alert_mailer
class NewApplicantAlertMailerPreview < ActionMailer::Preview
  def new_applicant_email
    NewApplicantAlertMailer.with(
      applicant: {
        email: "applicant@example.com",
        confirmation_token: "asdf1234",
      },
      site: SiteDefinitions::FACT_CHECK_INSIGHTS,
    ).new_applicant_email
  end
end
