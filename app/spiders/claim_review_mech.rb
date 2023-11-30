class ClaimReviewMech < Mechanize
  VALID_SCHEMES = ["http", "https"]

  def process(start_url: nil, scrapable_site: nil)
    scrapable_site.set_last_run_to_now && scrapable_site.checkin unless scrapable_site.nil?

    start_url = scrapable_site.url_to_scrape if start_url.nil? && !scrapable_site.nil?
    @base_host = URI.parse(start_url).host

    self.max_history = 0
    links_visited = []
    link_stack = [start_url]
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
          next if !host.nil? && host != @base_host # Make sure it's not a link to off the page

          next if host.nil? && !found_link.href.starts_with?("/") # wanna make sure it's not weird

          # Push it onto the stack, rewriting the url if necessary to be full
          url = host.nil? && found_link.href != "#" ? "#{page.uri.scheme}://#{initial_host}#{found_link.href}" : found_link.href
          next if links_visited.include?(url) || link_stack.include?(url) # Make sure we didn't see it yet

          link_stack.push(url)
        rescue URI::InvalidComponentError
          # Let's eat invalid URLs
          next
        rescue StandardError => e
          log_message("Error not caught with error #{e.message}", :error)
          log_message("Url: #{link}", :error)

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
              { "@context": "https://schema.org/" }.merge(object)
            end
          else
            j
          end
        rescue StandardError => e
          log_message("Error not caught with error #{e.message}", :error)
        end

        if json.count.positive? && json.first.is_a?(Array)
          json = json.first
        end

        json.each_with_index do |json_element, index|
          next unless json_element.key?("@type") && json_element["@type"] == "ClaimReview"

          # Sometimes there's spaces and such in the url, so we get rid of that
          json_element["url"] = json_element["url"].strip

          # Another AfricaCheck carve out
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

          # Check if this ClaimReview already exists
          # ClaimReview.find_duplicates(json_element["claimReviewed"], json_element["link"]), json_element["author"]["name"]
          begin
            claim_review = ClaimReview.create_or_update_from_claim_review_hash(json_element, "#{link}::#{index}", false)
            log_message("Created a claim_review at #{link} with id #{claim_review.id}", :info)
            found_claims_count += 1
            scrapable_site.update(number_of_claims_found: found_claims_count) unless scrapable_site.nil?
          rescue ClaimReview::DuplicateError
            log_message("Error filing a duplicate ClaimReview at #{link}", :error)
            # add_event(e.full_message) && return
          rescue StandardError => e
            log_message("Error filing a ClaimReview at #{link}", :error)
            log_message(e.full_message, :error) && next
          end
        rescue TypeError => e
          Honeybadger.notify(e, context: {
            link: link,
            json: json_element
          })
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
