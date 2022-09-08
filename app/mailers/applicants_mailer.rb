class ApplicantsMailer < ApplicationMailer
  def confirmation_email
    @applicant = params[:applicant]

    mail(to: @applicant[:email], subject: "Please confirm your email address for Fact-Check Insights")
  end
end
