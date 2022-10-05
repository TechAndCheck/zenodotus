class ApplicantsMailer < ApplicationMailer
  def confirmation_email
    @site = params[:site]
    @applicant = params[:applicant]

    mail({
      from: email_address_with_name("no-reply@mail.factcheckinsights.com", @site[:title]),
      to: @applicant[:email],
      subject: "Please confirm your email address for #{@site[:title]}"
    })
  end
end
