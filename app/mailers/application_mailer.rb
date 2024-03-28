# typed: false

class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name("no-reply@#{Figaro.env.MAIL_DOMAIN}", "Fact-Check Insights")
  layout "mailer"

  def scrape_complete_email
    mail(to: current_user.email, subject: "Media Vault Scrape Completed")
  end
end
