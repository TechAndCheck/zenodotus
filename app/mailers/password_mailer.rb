class PasswordMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.password_mailer.reset.subject
  #
  def reset
    @user = params[:user]
    @site = "Fact Check Insights"
    @token = @user.signed_id(purpose: "password_reset", expires_in: 1.hour)

    mail({
      from: email_address_with_name("no-reply@#{Figaro.env.MAIL_DOMAIN}", "Fact Check Insights"),
      to: @user.email,
      subject: "Please confirm your email address for #{@site}"
    })
    mail to: @user.email
  end
end
