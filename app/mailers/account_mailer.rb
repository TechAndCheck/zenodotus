class AccountMailer < ApplicationMailer
  def setup_email
    @site = params[:site]
    @token = params[:token]

    mail({
      from: email_address_with_name("no-reply@mail.factcheckinsights.com", @site[:title]),
      to: params[:user][:email],
      subject: "You’ve been approved for #{@site[:title]}!",
    })
  end
end
