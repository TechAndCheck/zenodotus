class Admin::WebScrapesController < AdminController
  def index
    @sites = ScrapableSite.all
  end

  def new
    @scrapable_site = ScrapableSite.new
  end

  def create
    @scrapable_site = ScrapableSite.new(scrapable_site_params)

    if @scrapable_site.save
      redirect_to new_admin_web_scrapes_path, notice: "Successfully added new scrapable web site"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def delete
    scrapable_site = ScrapableSite.find(params[:web_scrape_id])

    if scrapable_site.nil?
      redirect_back_or_to admin_web_scrapes_path, error: "No scrape with that ID found, this is a bad bug. Please report it."
    end


    if scrapable_site.delete
      redirect_back_or_to admin_web_scrapes_path, notice: "Successfully deleted web site"
    else
      redirect_back_or_to admin_web_scrapes_path, error: "Something went wrong deleting. Please report this."
    end
  end

  def scrape_now
    scrapable_site = ScrapableSite.find(params[:web_scrape_id])
    scrapable_site.scrape
    redirect_back_or_to admin_web_scrapes_path, notice: "Successfully scheduled new scrape to run immediately"
  end

private

  def scrapable_site_params
    params.require(:scrapable_site).permit(
      :name,
      :url,
      :starting_url,
    )
  end
end
