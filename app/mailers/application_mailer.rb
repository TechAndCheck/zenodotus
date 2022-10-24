# typed: false

class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name("no-reply@#{Figaro.env.MAIL_DOMAIN}", "Fact-Check Insights")
  layout "mailer"
end
