class ScrapeMailer < ApplicationMailer
  default from: "no-reply@#{Figaro.env.MAIL_DOMAIN}, Media Vault"
  layout "mailer"

  def scrape_complete_email
    @url = params[:url]

    mail({
      from: email_address_with_name("no-reply@#{Figaro.env.MAIL_DOMAIN}", "MediaVault"),
      to: params[:user][:email],
      subject: "MyVault Archive Request Completed",
    })
  end

  def scrape_removed_email
    @url = params[:url]
    @scrape_id = params[:scrape_id]

    mail({
      from: email_address_with_name("no-reply@#{Figaro.env.MAIL_DOMAIN}", "MediaVault"),
      to: params[:user][:email],
      subject: "MyVault Archive Request Failed",
    })
  end

  def scrape_error_email
    @url = params[:url]
    @scrape_id = params[:scrape_id]

    mail({
      from: email_address_with_name("no-reply@#{Figaro.env.MAIL_DOMAIN}", "MediaVault"),
      to: params[:user][:email],
      subject: "MyVault Archive Request Error",
    })
  end
end
