# Preview all emails at http://localhost:3000/rails/mailers/applicants_mailer
class ApplicantsMailerPreview < ActionMailer::Preview
  def confirmation_email
    ApplicantsMailer.with(
      applicant: {
        email: "applicant@example.com",
        confirmation_token: "asdf1234"
      }
    ).confirmation_email
  end
end
