class NewApplicantAlertMailer < ApplicationMailer
  def new_applicant_email
    @applicant = params[:applicant]
    # For aesthetic purposes
    @site = @applicant.source_site == "media_vault" ? SiteDefinitions::MEDIA_VAULT : SiteDefinitions::FACT_CHECK_INSIGHTS

    # Send an email to all admins
    admins = User.with_role(:admin)
    admin_emails = admins.map { |admin| admin.email }

    mail({
      from: email_address_with_name("no-reply@#{Figaro.env.MAIL_DOMAIN}", @site[:title]),
      to: admin_emails,
      subject: "New user application for #{@site[:title]}"
    })
  end
end
