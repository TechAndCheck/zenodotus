class GoogleSearchResult < ApplicationRecord
  def public_image_url
    Rails.cache.fetch("#{cache_key_with_version}/#{self.id}", expires_in: 24.hours) do
      hydra = Typhoeus::Hydra.hydra
      request = Typhoeus::Request.new(self.image_url, followlocation: true)
      hydra.queue(request)
      hydra.run

      request.response.body
    end
  end

  def self.from_api_response(api_response)
    response = self.new
    response.text = api_response["text"]
    response.claimant = api_response["claimant"]
    response.claim_date = DateTime.parse(api_response["claimDate"]) unless api_response["claimDate"].nil?
    response.url = api_response["claimReview"].first["url"]
    response.review_date = DateTime.parse(api_response["claimReview"].first["reviewDate"]) unless api_response["claimReview"].first["reviewDate"].nil?
    response.rating = api_response["claimReview"].first["textualRating"]
    response.title = api_response["claimReview"].first["title"]
    response.language_code = api_response["claimReview"].first["languageCode"]
    response.publisher_name = api_response["claimReview"].first["publisher"]["name"]
    response.publisher_site = api_response["claimReview"].first["publisher"]["site"]

    response
  end
end
