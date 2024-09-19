class ScrapeFactCheckSite::UpdateNodesJob < ApplicationJob
  queue_as :web_scrapes_graph_update
  sidekiq_options retry: true

  def perform(links_to_update: [], current_crawler_page_id: nil, crawler_run_id: nil)
    current_crawler_page = CrawledPage.find(current_crawler_page_id) unless current_crawler_page_id.nil?

    links_to_update.each do |link|
      page = CrawledPage.find_by(url: link)

      # Multi use!
      unless current_crawler_page.nil?
        # Add the current page to the in links
        page.crawled_pages_in << current_crawler_page
        # Add the page to the out links
        current_crawler_page.crawled_pages_out << page
      end

      # Add the page to the current crawler run
      page.update!(last_crawler_run_id: crawler_run_id, last_crawled_at: Time.now) unless crawler_run_id.nil?
    end
  end
end
