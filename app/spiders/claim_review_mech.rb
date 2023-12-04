class ClaimReviewMech < Mechanize
  VALID_SCHEMES = ["http", "https"]

  def process(start_url: nil, scrapable_site: nil, links_visited: nil, link_stack: nil, backoff_time: 0)
    scrapable_site.set_last_run_to_now && scrapable_site.checkin unless scrapable_site.nil?

    # Figure out which url we should be scraping, 1. start_url, 2. scrapable_site.url_to_scrape, 3. scrapable_site.url
    if start_url.nil?
      start_url = scrapable_site.url_to_scrape.blank? ? scrapable_site.url : scrapable_site.url_to_scrape
    end

    @base_host = URI.parse(start_url).host

    self.max_history = 0
    links_visited = [] if links_visited.nil?
    link_stack = [start_url] if link_stack.nil?
    initial_host = URI.parse(start_url).host

    found_claims_count = scrapable_site.nil? ? 0 : scrapable_site.number_of_claims_found
    start_time = Time.now

    log_message("Beginning scraping", :info)

    progress_counter = 0 # For status purposes we want to only output logging every 50 links or so
    while link_stack.count.positive? do
      link = link_stack.pop
      links_visited << link

      log_level = :debug

      if (progress_counter % 100).zero?
        scrapable_site.checkin # Every 100, check in
        log_level = :info
      end

      log_message("Navigating to new link #{link}", log_level)

      begin
        sleep(backoff_time) if backoff_time.positive? # If we're being rate limited, wait a bit
        page = get(link)
      rescue Mechanize::ResponseCodeError => e
        if page.nil? # no idea why this happens, but it does occasionally
          self.history.push(page, link)
        else
          self.history.push(page, page.uri) unless page.nil?
        end

        case e.response_code
        when "404", "403", "500", "503"
          # Move on
          next
        when "429"
          # We're being rate limited, so we need to reschedule this scrape. Say in five minutes
          backoff_time += 0.5
          log_message("Rate limited, rescheduling to #{backoff_time}", :info)
          ScrapeFactCheckSiteJob.set(wait: 5.minutes).perform_later(start_url: start_url, scrapable_site: scrapable_site, links_visited: links_visited, link_stack: link_stack, backoff_time: backoff_time)
          return
        else
          log_message("Error not caught with response code #{e.response_code}", :error)
          next
        end
      rescue Mechanize::RedirectLimitReachedError,
             Errno::ECONNRESET,
             OpenSSL::SSL::SSLError,
             Mechanize::ResponseReadError,
             Net::OpenTimeout,
             SocketError
        next # Skip all the various things that can go wrong
      rescue StandardError => e
        log_message("Error not caught with error #{e.message}", :error)
        next
      end

      next unless page.is_a?(Mechanize::Page) # We're not doing files

      # Skip non-sites too
      if page.response.key?("content-type") && !page.response["content-type"].include?("text/html")
        next
      end

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

          # Push it onto the stack, rewriting the url if necessary to be full
          url = host.nil? && found_link.href != "#" ? "#{page.uri.scheme}://#{initial_host}#{found_link.href}" : found_link.href
          next if links_visited.include?(url) || link_stack.include?(url) # Make sure we didn't see it yet

          url = URI::Parser.new.escape(url) # Clean up the URL if there's non-ASCII characters

          link_stack.push(url)
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

        script_elements = page.search("//script[@type='application/ld+json']").map(&:text)

      rescue Nokogiri::XML::SyntaxError => e
        log_message("Nokogiri parsing error #{e.message}", :error)
        log_message("Url: #{link}", :error)

        Honeybadger.notify(e, context: {
          link: link,
          page: page
        })

        # go to next if the page can't be parsed
        next
      end

      # Check the page for ClaimReview
      script_elements.each do |script_element|
        begin
          json = JSON.parse(script_element)
        rescue StandardError => e
          # Let's ignore bad JSON
          next
        end


        # One off for AfricaCheck
        json = (json.is_a?(Array) ? json : [json]).map do |j|
          if j.has_key?("@graph") && j["@graph"].is_a?(Array)
            j["@graph"].map do |object|
              object ||= {}
              next if object.is_a?(Array) # If it's an array, it's probably not what we're looking for

              { "@context": "https://schema.org/" }.merge(object)
            end
          else
            j
          end
        rescue StandardError => e
          log_message("Error not caught with error #{e.message}", :error)
          Honeybadger.notify(e, context: {
            link: link,
            page: page
          })
        end

        if json.count.positive? && json.first.is_a?(Array)
          json = json.first
        end

        json.each_with_index do |json_element, index|
          json_element = [json_element] unless json_element.is_a?(Array)

          json_element.each_with_index do |element, index|
            if extract_schema_review(element, link, index) # Returns true if properly extracted, false otherwise
              found_claims_count += 1
              scrapable_site.update(number_of_claims_found: found_claims_count) unless scrapable_site.nil?
            end
          end
        end
      rescue StandardError => e
        Honeybadger.notify(e, context: {
          link: link
        })
      end

      GC.start if (progress_counter % 50).zero? # We force garbage collection for memory purposes
      progress_counter += 1 # Keep the count up
    end

    # Hey! We're done, close up shop
    log_message("Ending scraping", :info)

    end_time = Time.now - start_time
    scrapable_site.finish_scrape unless scrapable_site.nil?

    { found_claims_count: found_claims_count, time_elapsed: end_time }
  end

  def extract_schema_review(json_element, link, index)
    return false unless json_element.is_a?(Hash) && json_element.key?("@type") && json_element["@type"] == "ClaimReview"

    # Sometimes there's spaces and such in the url, so we get rid of that
    json_element["url"] = json_element["url"].strip

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
      return false
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
  end
end
