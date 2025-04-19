# require "active_graph"

class CrawledPage
  # include ActiveGraph::Node
  # include ActiveGraph::Timestamps # will give model created_at and updated_at timestamps

  # property :url, type: String
  # property :host_name, type: String
  # property :has_claim_review, type: Boolean, default: false
  # property :number_of_claims_linked, type: Integer, default: 0
  # property :last_crawled_at, type: DateTime
  # property :last_crawler_run_id, type: String, default: ""
  # property :crawlable_site_id, type: String

  # validates :url, presence: true
  # validates :host_name, presence: true
  # validates :number_of_claims_linked, numericality: { only_integer: true }

  # # For some reason validating uniquness doesn't work and I don't care at this point :-)
  # # validates :url, uniqueness: true

  # has_many :out, :crawled_pages_out, type: :crawled_page, model_class: :CrawledPage, unique: true, dependent: :delete
  # has_many :in, :crawled_pages_in, type: :crawled_page, model_class: :CrawledPage, unique: true, dependent: nil

  # #### THIS DOESN"T WORK FOR SOME REASON
  # before_validation :set_host_name

  # def set_host_name
  #   self.host_name = URI(url).host if self.host_name.nil?
  # end

  # def last_crawler_run
  #   CrawlerRun.find(last_crawler_run_id)
  # end
end
