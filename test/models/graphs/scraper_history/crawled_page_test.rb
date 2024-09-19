# require "test_helper"

# class CrawledPageTest < ActiveSupport::TestCase
#   def setup
#     ActiveGraph::Base.query('MATCH (n) DETACH DELETE n')
#   end

#   def teardown
#     ActiveGraph::Base.query('MATCH (n) DETACH DELETE n')
#   end

#   def test_creating_a_crawled_page_node
#     crawled_page = CrawledPage.create(url: "https://example.com")
#     assert_not crawled_page.nil?
#   end

#   def test_crawled_page_node_requires_url
#     crawled_page = CrawledPage.create(host_name: "example.com")
#     assert_predicate crawled_page.url, :nil?
#   end

#   def test_crawled_page_node_requires_host_name
#     crawled_page = CrawledPage.create(url: "https://example.com")
#     assert_not crawled_page.host_name.nil?
#   end

#   def test_crawled_page_node_requires_url_and_host_name
#     assert_raises ArgumentError do
#       crawled_page = CrawledPage.create
#     end
#   end

#   # Whatever for now
#   def test_page_node_requires_url_to_be_unique
#     crawled_page = CrawledPage.create(url: "https://example.com")
#     assert_not crawled_page.nil?

#     assert_raises Neo4j::Driver::Exceptions::ClientException do
#       crawled_page = CrawledPage.create(url: "https://example.com")
#     end
#   end

#   def test_can_find_crawled_page_by_url
#     crawled_page = CrawledPage.create(url: "https://example.com")

#     found_page = CrawledPage.find_by(url: "https://example.com")
#     assert_not found_page.nil?
#     assert_equal crawled_page, found_page
#   end

#   def test_can_find_crawled_page_by_host_name
#     crawled_page = CrawledPage.create(url: "https://example.com")

#     found_page = CrawledPage.find_by(host_name: "example.com")
#     assert_not found_page.nil?
#     assert_equal crawled_page, found_page
#   end

#   def test_can_add_edge_between_two_nodes
#     crawled_page_one = CrawledPage.create(url: "https://example.com")
#     crawled_page_two = CrawledPage.create(url: "https://example.com/2")

#     crawled_page_one.crawled_pages_out << crawled_page_two
#     assert_equal 1, crawled_page_one.crawled_pages_out.count
#   end

#   def test_node_has_nil_last_scraped_at_timestamp
#     crawled_page_one = CrawledPage.create(url: "https://example.com")
#     assert_nil crawled_page_one.last_scraped_at
#   end

#   def test_node_can_be_assigned__last_scraped_at_timestamp
#     crawled_page_one = CrawledPage.create(url: "https://example.com")
#     crawled_page_one.update(last_scraped_at: DateTime.now)
#     assert_not_nil crawled_page_one.last_scraped_at
#   end
# end
