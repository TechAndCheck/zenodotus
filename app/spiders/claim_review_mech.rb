require "sidekiq/api"

# Algorithm

# 1. Find page, save it as a page
# 2. If page has ClaimReview, mark all *in* connections as positive
# 3. Find links on the page, check if any have been checked already
#    Skip if the page is from a different domain
# 4. If it has been, add self as an *in* link and mark it as visited and positive if the page has CR on it
# 5. If it hasn't been checked create a new page, add self to the *in* and visited and positive to false
# 6. Get a list of all unvistited out edges for the domain, visit next page
# 7. If no unvisited pages stop

# OK, so saving nodes is SLOW. LIKE REALLY REALLY SLOW.
# So instead we'll mirror some of it in memory or maybe in a redis store... Should we use postgres instead?
#
# We can assume there's enough nodes that we can always get a next one, since the first pass is the only time
# there won't be more than one node to visit. That means, we can save the links in memory and offload the saving to another job
#
# 1.) At the start, get all the links, save in memory from neo4j
# 2.) Request the next page
# 3.) Check if the links already exists in the links list
# 4.) Job to update the current node with the new links out, and the node with the link in for this node
# 5.) If the link doesn't exist, create a new node, add the link to the links list, and add the link in for this node
# 6.) If there are no more links, stop

# We should set runs as an id as well, this can be a regular model I think
# The run can say how long it took, when it took, number of new stuff found, number of nodes visited

# Determine what is probably a node for the most, rescan those most often

class ClaimReviewMech < Mechanize
  VALID_SCHEMES = ["http", "https"]
  NUMBER_OF_SCRAPES_WITHOUT_CR_BEFORE_SKIPPING = 100

  SCRAPE_TYPE = [:full, :update]

  module NodeStub
    attr_reader :url, :id

    def initialize(url: nil, id: nil)
      @url = url
      @id = id
    end
  end

  # Begin the process of scraping a site
  #
  # @param [CrawlableSite] crawlable_site The site to scrape
  # @param [Integer] backoff_time The time to wait between requests
  # @param [Integer] max_pages The maximum number of pages to scrape
  # @param [Symbol] scrape_type The type of scrape to perform
  #
  # @return [Hash] The results of the scrape found_claims_count: number of claims found, pages_scraped_count: number of pages scraped
  def process(crawlable_site: nil, backoff_time: 0, max_pages: -1, scrape_type: :full)
    raise "Invalid scrape type" unless SCRAPE_TYPE.include?(scrape_type)

    get_all_known_pages(crawlable_site)

    # Create a scrape run
    # TEMPORARY: We're going to start at the beginning every time we start a new scrape
    # scrape_run = CrawlerRun.create(starting_url: crawlable_site.url_to_scrape, host_name: @base_host, started_at: Time.now)
    @crawler_run = CrawlerRun.create!(started_at: Time.now,
                                      starting_url: crawlable_site.url_to_scrape,
                                      host_name: crawlable_site.url_host_name)

    crawlable_site.set_last_run_to_now && crawlable_site.checkin unless crawlable_site.nil?

    counter = 0
    new_claims_found = 0

    loop do
      # Get a list of nodes not crawled in this session yet
      node_stub = nil
      begin
        node_stub = get_page_to_crawl(crawlable_site, scrape_type: scrape_type)
      rescue Neo4j::Driver::Exceptions::ClientException
        # There's an edge case (testing especially) where there's not a page to retrieve in the initial scraping
        # IN which case this eror gets thrown and we just skip out
        break
      end

      # Get Page
      page = retrieve_page(node_stub.url)

      # Check if the page has a ClaimReview on it
      next unless valid_page?(node_stub)

      claims_found = find_schema_review(page, node_stub)
      new_claims_found += claims_found
      logger.info "Found claims: #{claims_found} for url #{node_stub.url}"

      # Increment the number of claims linked for all pages that link to this
      crawler_page.crawled_pages_in.each do |in_page|
        in_page.update(number_of_claims_linked: in_page.number_of_claims_linked + 1)
      end if claims_found
      # Find all the links on the page
      find_links_and_create_pages(page, node_stub)

      # For testing we can break after a certain number of pages
      if max_pages.positive?
        break if counter > max_pages
        counter += 1
      end
    end

    # Hey! We're done, close up shop
    log_message("Ending scraping", :info)

    crawlable_site.finish_scrape unless crawlable_site.nil?
    @crawler_run.finish

    { found_claims_count: new_claims_found, time_elapsed: @crawler_run.elapsed_time }
  end

  # Get the contents of a page
  #
  # @param [String] url The URL of the page to retrieve
  #
  # @return [Mechanize::Page] The page
  def retrieve_page(url)
    # We're going to use the Mechanize gem to get the page
    get(url)

    # We're going to return the page
    page
  rescue Mechanize::ResponseCodeError => e
    log_message("Error retrieving page: #{e.message}", :error)
    nil
  end

  # Get the next page from the graph database to crawl for this site
  #
  # @param [CrawlableSite] crawlable_site The site to retrieve the next page for
  #
  # @return [CrawledPage] The next page to crawl, nil if nothing else to crawl
  def get_page_to_crawl(crawlable_site, scrape_type: :full)
    # NEW THING: All links will be popped off an in-memory Queue
    # we will reup the queue every 50 urls (NOT PAGES) or so, or when it's empty
    # The reup will only get the links that have not been crawled in this session

    # Eventually we'll add more conditions including things such as
    # not having claim review on the page, linking to a page with a claim review, etc.
    #
    #

    if @fill_count.nil? || @fill_count > NUMBER_OF_SCRAPES_WITHOUT_CR_BEFORE_SKIPPING
      @fill_count = 0
      fill_links_queue(crawlable_site)
    end

    next_url = nil
    5.times do
      next_url = @links_queue.pop
      break unless next_url.nil?

      # This could create a race condition, and we may not need to check at all since theoretically it's only happen at the end of the scrape
      # web_scrape_queue = Sidekiq::Queue.all.first { |q| q.end_with?("web_scrapes_graph_update") }
      # break if web_scrape_queue.size == 0 # We're done scraping

      sleep(3) # sleep before the next loop to wait for some jobs to load up possible nodes
    end

    return nil if next_url.nil?

    # This is if there's no page yet created. Only useful for the first run of a new site

    #   next_page = CrawledPage.create!(url: crawlable_site.url_to_scrape, crawlable_site_id: crawlable_site.id, last_crawler_run_id: @crawler_run.id, last_crawled_at: DateTime.now)
    # else
    # links_to_update: [], current_crawler_page_id: nil
    ScrapeFactCheckSite::UpdateNodesJob.perform_later(links_to_update: [next_url.url])
    # next_page.update!(last_crawler_run_id: @crawler_run.id, last_crawled_at: DateTime.now)
    # end

    next_url
  end

  def fill_links_queue(crawlable_site)
    links_found =  case scrape_type
                   when :full
                     CrawledPage.where("crawlable_site_id": crawlable_site.id)
                       .where_not("last_crawler_run_id": @crawler_run.id).pluck(:url, :id)
                   when :update
                     CrawledPage.where("crawlable_site_id": crawlable_site.id)
                       .where_not("last_crawler_run_id": @crawler_run.id)
                       .where(has_claim_review: false)
                       .where(" COUNT { (c)-[cs]->(:CrawledPage) } > 0").pluck(:url, :id)
                   else
                     raise "Invalid scrape type"
    end
    # We should find only those that link to pages that have claim reviews maybe?
    # At some point we want to have different types of scrapes, full, partial, rechecks etc.
    # We'll want this to decide for itself what type of scrape it should commit

    @links_queue = links_found.map { |url, id| NodeStub.new(url: url, id: id) }
  end

  # Get all links on a page using a bunch of heuristics that I've come up with
  #
  # @param [Mechanize::Page] page The page to find links on
  #
  # @return [Array] An array of the links found, or false if no links were found
  def find_links(page)
    links = []

    # Add all the links on the current page
    begin
      page.links.each do |found_link|
        # Now we make sure that a bunch of things are satisfied before visiting later
        # Check if we've been there yet
        begin
          next if found_link.uri.nil? # Weird links may not have a URI
        rescue URI::InvalidURIError
          next # The URI isn't really doable.
        end

        # You may think you could simplify this with a null check ala `found_link.uri&.host`
        # this won't work because it'll make it nil, which will screw up the logic on the next page

        # Make sure we're only following http/https links (empty is assumed to be fine)
        next unless found_link.uri.scheme.nil? || VALID_SCHEMES.include?(found_link.uri.scheme)

        host = found_link.uri.host
        next if !host.nil? && host != @base_host                # Make sure it's not a link to off the page
        next if host.nil? && !found_link.href.starts_with?("/") # wanna make sure it's not weird
        next if found_link.uri.path.ends_with?(".shtml")        # We don't want to follow SHTML files
        next if found_link.uri.fragment.present?                # We don't want to follow links with fragments

        # Don't add the same link we're on if there's a link to that for some reason
        next if found_link.uri.to_s == page.uri.to_s

        # One off for Teyit, because it's real weird
        next if !found_link.uri.query.nil? && found_link.uri.query.scan(/25/).length > 3

        # Push it onto the stack, rewriting the url if necessary to be full
        url = host.nil? && found_link.href != "#" ? "#{page.uri.scheme}://#{page.uri.host}#{found_link.href}" : found_link.href
        # next if links_visited.include?(url) || link_stack.include?(url) # Make sure we didn't see it yet

        url = URI::Parser.new.escape(url) # Clean up the URL if there's non-ASCII characters

        links.push(url)
      rescue URI::InvalidComponentError, Nokogiri::XML::SyntaxError
        # Let's eat invalid URLs, occasionally we'll get a .shtml file, which... let's assume here
        next
      rescue StandardError => e
        log_message("Error not caught with error #{e.message}", :error)
        log_message("Url: #{found_link}", :error)

        Honeybadger.notify(e, context: {
          link: found_link
        })
      end
    rescue Nokogiri::XML::SyntaxError => e
      log_message("Nokogiri parsing error #{e.message}", :error)
      log_message("Url: #{link}", :error)

      Honeybadger.notify(e, context: {
        link: link,
        page: page
      })

      # go to next if the page can't be parsed
      return false
    end

    links
  end

  # Check if a page is valid for scraping
  #
  # @param [Mechanize::Page] page The page to verify
  #
  # @return [Boolean] if the page is valid for scraping
  def valid_page?(page)
    return false unless page.is_a?(Mechanize::Page)

    # We're going to skip pages that aren't text/html
    return false if page.response.key?("content-type") && !page.response["content-type"].include?("text/html")

    true
  end

  # Check if a page has a schema review on it by iterating through the JSON-LD elements
  #
  # @param [Mechanize::Page] page The page to check on it
  # @param [CrawledPage] crawler_page The page that we're crawling
  #
  # @return [Integer] The number of schema reviews found
  def find_schema_review(page, node_stub)
    script_elements = page.search("//script[@type='application/ld+json']").map(&:text)

    # We're going to check if the page has a ClaimReview on it
    schema_review_count = 0

    script_elements.each_with_index do |script_element, index|
      json_element = JSON.parse(script_element)
      json_element = [json_element] if json_element.is_a?(Hash)

      json_element.each do |element|
        schema_review_count += 1 if extract_schema_review(element, node_stub.url, index)
      end
    end

    # TODO: THROW OUT A JOB FOR THIS IF IT'S A CLAIM REVIEW
    crawler_page.update(has_claim_review: true) if schema_review_count.positive?

    schema_review_count
  end

  # Extract all the ClaimReview schema elements from a JSON element
  #
  # @param [Mechanize::Element] json_element The JSON element to check
  # @param [String] link The link that the JSON element was found on
  # @param [Integer] index The index of the JSON element (NOTE: Not sure if this is necessary, but it's here for now)
  #
  # @return [Boolean] If the JSON Element successfully saved a ClaimReview to the database
  def extract_schema_review(json_element, link, index)
    return false unless is_valid_schema_for_claim_review(json_element)

    # Sometimes there's spaces and such in the url, so we get rid of that
    json_element["url"] = json_element["url"].strip

    # Sometimes the url doesn't have the scheme on it, breaking parsing
    unless json_element["url"].starts_with?("http://") || json_element["url"].starts_with?("https://")
      json_element["url"] = "https://#{json_element["url"]}" # We're making a big assumption here...
    end

    # Encode the url properly in case there's non-ASCII characters
    json_element["url"] = URI.parse(URI::Parser.new.escape(json_element["url"]))

    # Sometimes the author is a string, so we make it an object
    # This one is a rewrite, because they link to the journalist's profile,
    # which breaks our deduplication process entirely
    if URI(json_element["url"]).host == "africacheck.org" && json_element["author"].is_a?(String) && json_element["author"].ends_with?("Array")
      json_element["author"] = {
        "@type": "Organization",
        "name": "Africa Check",
        "url": "https://africacheck.org"
      }
    end

    # Occasionally a site will use "publisher" instead of "author", so we want to rename that
    if (!json_element.key?("author") || json_element["author"].blank?) && (json_element.key?("publisher"))
      json_element["author"] = json_element["publisher"]
    end

    # Rarely the author can be an array, if so we grab the first one
    if json_element["author"].is_a?(Array)
      json_element["author"] = json_element["author"].count.positive? ? json_element["author"].first : {}
    end

    if !json_element["author"].has_key?("url") || json_element["author"]["url"].empty?
      uri = URI(json_element["url"])
      json_element["author"]["url"] = "#{uri.scheme}://#{uri.host}"
    end

    # Rarely the `claimReviewed` field is in `description` instead, so we'll flip it
    if !json_element.has_key?("claimReviewed") && json_element.has_key?("description") && json_element["description"].is_a?(String)
      json_element["claimReviewed"] = json_element["description"]
      json_element["description"] = nil
    end

    # Rarely the `claimReviewed` field is in `name` instead, so we'll flip it
    if !json_element.has_key?("claimReviewed") && json_element.has_key?("name") && json_element["name"].is_a?(String)
      json_element["claimReviewed"] = json_element["name"]
      json_element["name"] = nil
    end

    # If `claimReviewed` is still nil we'll move on
    if !json_element.has_key?("claimReviewed") || json_element["claimReviewed"].nil?
      return false
    end

    # Check if this ClaimReview already exists
    # ClaimReview.find_duplicates(json_element["claimReviewed"], json_element["link"]), json_element["author"]["name"]
    begin
      claim_review = ClaimReview.create_or_update_from_claim_review_hash(json_element, "#{link}::#{index}", false)
      log_message("Created a claim_review at #{link} with id #{claim_review.id}", :info)
    rescue ClaimReview::DuplicateError
      log_message("Error filing a duplicate ClaimReview at #{link}", :error)
      return true # We still want to return as true so that we keep scraping even if it's in our database
    rescue StandardError => e
      log_message("Error filing a ClaimReview at #{link}", :error)
      log_message(e.full_message, :error)

      Honeybadger.notify(e, context: {
        link: link
      })

      return false
    end

    true
  rescue StandardError => e
    Honeybadger.notify(e, context: {
      link: link,
      json: json_element
    })

    false
  end

  # Check if the schema in an element is valid ClaimReview.
  #
  # @param [JSON] json_element The JSON element to check
  #
  # @return [true] if the JSON element is a valid ClaimReview schema element
  def is_valid_schema_for_claim_review(json_element)
    return false unless json_element.is_a?(Hash) && json_element.key?("@type")
    return true if json_element["@type"].is_a?(String) && json_element["@type"] == "ClaimReview"
    return true if json_element["@type"].is_a?(Array) && json_element["@type"].include?("ClaimReview")

    false
  end

  # Find all links and make a CrawledPage for each one.
  #
  # @param [Mechanize::Page] page The page to find links on
  # @param [CrawledPage] current_crawler_page The current page we're on, so we can properly link the pages
  #
  # @return [true] if the links were successfully found and pages created
  def find_links_and_create_pages(page, current_node_stub)
    # Find all the links on the page
    links = find_links(page)

    # Go through the links, check if they've been visited
    # If they haven't been visited, create a new page
    # Add the current page to the in links
    # Add the page to the current out links
    # If they have been visited, update the number of claims linked

    # link_hash = links.map { |link| { url: link, crawlable_site_id: current_crawler_page.crawlable_site_id }}
    # pages = CrawledPage.create(link_hash)

    # page.crawled_pages_in << pages

    # pages.each do |page|
    #   current_crawler_page.crawled_pages_out << page
    # end

    links_to_create = []
    links_to_update = []

    links.each do |link|
      # Check if the link has been visited
      page = nil
      if @links_found.include?(link)
        links_to_update << link
      else
        @links_found << link
        links_to_create << link
      end
    end

    ScrapeFactCheckSite::SaveNodesJob.perform_later(links_to_create: links_to_create, current_crawler_page_id: current_node_stub.id) unless links_to_create.empty?
    ScrapeFactCheckSite::UpdateNodesJob.perform_later(links_to_update: links_to_update, current_crawler_page_id: current_node_stub.id) unless links_to_update.empty?

    @links_found.concat(links)

    true
  end

  # Log error messages to the Rails logger.
  #
  # @param [String] text The message to log
  # @param [Symbol] level The log level to use
  #
  # @return [true] if the message was successfully logged
  def log_message(text, level = :debug)
    @base_host ||= "Unknown"
    message = "Scraper: #{@base_host} | #{text}"

    case level
    when :debug
      Rails.logger.debug(message)
    when :info
      Rails.logger.info(message)
    when :error
      Rails.logger.error(message)
    else
      raise "Invalid log level #{level}"
    end

    true
  end
end
