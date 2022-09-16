class AccountMailer < ApplicationMailer
  def setup_email
    @token = params[:token]

    mail(to: params[:user][:email], subject: "You’ve been approved for Fact-Check Insights!")
  end
end
