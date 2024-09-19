class ScrapeFactCheckSite::SaveNodesJob < ApplicationJob
  queue_as :web_scrapes_graph_update
  sidekiq_options retry: true

  def perform(links_to_create: [], current_crawler_page_id: nil)
    current_crawler_page = CrawledPage.find(current_crawler_page_id)

    links_to_create.each do |link|
      page = create_page_from_link(link, current_crawler_page) if page.nil?
      current_crawler_page.crawled_pages_out << page
      page.crawled_pages_in << current_crawler_page
    rescue Neo4j::Driver::Exceptions::ClientException
      next
    end
  end

  def create_page_from_link(link, current_crawler_page)
    CrawledPage.create(url: link, crawlable_site_id: current_crawler_page.crawlable_site_id, crawled_pages_in: [current_crawler_page])
  end
end
