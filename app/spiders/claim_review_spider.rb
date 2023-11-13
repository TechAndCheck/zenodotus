# To start ```ClaimReviewSpider.parse!(:parse, url: "https://theferret.scot/")```

class ClaimReviewSpider < Tanakai::Base
  @config = {
    skip_duplicate_requests: true,
    skip_request_errors: [
      { error: RuntimeError, message: "404 => Net::HTTPNotFound" },
      { error: RuntimeError, message: "410 => Net::HTTPGone" },
    ],
    restart_if: {
      requests_limit: 100
    },
    retry_request_errors: [Net::ReadTimeout],
    restart_if: {
      requests_limit: 100
    },
    # before_request: { delay: 1..2 }
  }

  @name = "claim_review_spider"
  @engine = :mechanize

  def parse(response, url:, data: {})
    # request_to(:parse_claim_review_script_tags, url: url)
    parse_claim_review_script_tags(response, url)

    # Collect urls
    uri = URI(url)
    scheme = uri.scheme
    host = uri.host
    base_url = "#{scheme}://#{host}"

    # Get all the links in the page that point to our current domain (or the relative path)
    links = response.xpath("//a").map { |link| link[:href] }
    links = links.map do |link|
      next if link == url # don't crawl ourselves
      link = link&.starts_with?("/") ? "#{base_url}#{link}" : link # if it's relative, add the base_url
      link if link&.starts_with?(base_url)
    end.compact_blank!

    # links.each do |link|
    #   next unless link.ascii_only? && URI.parse(link).host == host

    #   request_to(:parse, url: link) if unique?(:url, link)
    # end

    in_parallel(:parse, links, threads: 1)
  end

  def parse_claim_review_script_tags(response, url)
    script_elements = response.xpath("//script[@type='application/ld+json']").map(&:text)
    script_elements.each do |script_element|
      json = JSON.parse(script_element)
      json_elements = json.is_a?(Array) ? json : [json]

      json_elements.each_with_index do |json_element, index|
        begin
          next unless json_element["@type"] == "ClaimReview"
        rescue StandardError
          # we'll eat parsing errors
        end

        # Check if this ClaimReview already exists
        # ClaimReview.find_duplicates(json_element["claimReviewed"], json_element["url"]), json_element["author"]["name"]
        begin
          claim_review = ClaimReview.create_or_update_from_claim_review_hash(json_element, "#{url}::#{index}", false)
          add_event("Created a claim_review at #{url} with id #{claim_review.id}")
        rescue ClaimReview::DuplicateError
          add_event("Error filing a duplicate ClaimReview at #{url}")
          # add_event(e.full_message) && return
        rescue StandardError => e
          add_event("Error filing a ClaimReview at #{url}")
          add_event(e.full_message) && return
        end
      end
    end
  end
end
