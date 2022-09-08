# typed: false
class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name("no-reply@mail.factcheckinsights.com", "Fact-Check Insights")
  layout "mailer"
end
