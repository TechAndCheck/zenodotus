class Admin::WebScrapesController < AdminController
  def index
    @sites = ScrapableSite.all.order(:name)
  end

  def new
    @scrapable_site = ScrapableSite.new
  end

  def create
    @scrapable_site = ScrapableSite.new(scrapable_site_params)

    if @scrapable_site.save
      redirect_to new_admin_web_scrape_path, notice: "Successfully added new scrapable web site"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
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

  def handle_form
    site_ids = params[:sites_selected]

    case params[:route_to].keys.first.to_sym
    when :scrape_group
      scrape_selected(site_ids)
    when :delete_group
      delete_selected(site_ids)
    end

    redirect_back_or_to admin_web_scrapes_path
  end

  def scrape_now
    scrapable_site = ScrapableSite.find(params[:web_scrape_id])
    scrapable_site.scrape
    redirect_back_or_to admin_web_scrapes_path, notice: "Successfully scheduled new scrape to run immediately"
  end

private

  def process_selected(site_ids, &block)
    return "No block given" unless block_given?
    success_count = 0
    site_ids&.each do |site_id|
      site = ScrapableSite.find(site_id)
      unless site.nil?
        block.call(site)
        success_count += 1
      end
    end

    success_count
  end

  def scrape_selected(site_ids)
    success_count = process_selected(site_ids) { |site| site.scrape }
    flash[:success] = "Successfully scheduled #{success_count} new #{"scrape".pluralize(success_count)} to run immediately"
  end

  def delete_selected(site_ids)
    success_count = process_selected(site_ids) { |site| site.destroy }
    flash[:success] = "Successfully deleted #{success_count} scrape organizations"
  end

  def scrapable_site_params
    params.require(:scrapable_site).permit(
      :name,
      :url,
      :starting_url,
    )
  end
end
