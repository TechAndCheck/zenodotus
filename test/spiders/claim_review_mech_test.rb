# require "test_helper"

# class ClaimReviewMechTest < ActiveSupport::TestCase
#   include ActiveJob::TestHelper
#   include Minitest::Hooks

#   def setup
#     ActiveGraph::Base.query('MATCH (n) DETACH DELETE n')
#   end

#   def teardown
#     ActiveGraph::Base.query('MATCH (n) DETACH DELETE n')
#   end

#   def before_all
#     ActiveGraph::Base.query('MATCH (n) DETACH DELETE n')
#   end

#   test "can begin processing" do
#     ClaimReviewMech.new.process(crawlable_site: crawlable_sites(:one))
#   end

#   test "processing creates at least one node" do
#     ClaimReviewMech.new.process(crawlable_site: crawlable_sites(:one))
#     assert_equal 1, CrawledPage.count
#   end

#   test "processing can find links" do
#     crawlable_site = crawlable_sites(:fullfact)
#     max_pages = 30

#     perform_enqueued_jobs do
#       results = ClaimReviewMech.new.process(crawlable_site: crawlable_sites(:fullfact), max_pages: 10, scrape_type: :full)
#     end

#     assert CrawledPage.count > 1
#   end

#   test "secondary processing can relook" do
#     crawlable_site = crawlable_sites(:fullfact)
#     results = ClaimReviewMech.new.process(crawlable_site: crawlable_sites(:fullfact), max_pages: 10, scrape_type: :full)

#     results = ClaimReviewMech.new.process(crawlable_site: crawlable_sites(:fullfact), max_pages: 10, scrape_type: :update)
#     assert CrawledPage.count > 1
#   end
# end
