# typed: ignore

class MediaVault::IngestController < MediaVaultController
  skip_before_action :authenticate_user!
  skip_before_action :must_be_media_vault_user

  before_action :authenticate_user_from_api_key!

  class ApiResponseCodes < T::Enum
    extend T::Sig

    enums do
      Success = new
    end

    sig { returns(Integer) }
    def code
      case self
      when Success then 20
      else T.absurd(self)
      end
    end

    sig { returns(String) }
    def message
      case self
      when Success then "Successfully archived media object"
      else T.absurd(self)
      end
    end
  end

  class ApiErrors < T::Enum
    extend T::Sig

    enums do
      JSONParseError = new
      JSONValidationError = new
    end

    class JSONParseException < StandardError
      def message
        JSONParseError.message
      end
    end

    class JSONValidationException < StandardError
      def message
        JSONValidationError.message
      end
    end

    sig { returns(Integer) }
    def code
      case self
      when JSONParseError then 10
      when JSONValidationError then 11
      else T.absurd(self)
      end
    end

    sig { returns(String) }
    def message
      case self
      when JSONParseError then "Error parsing JSON, invalid JSON"
      when JSONValidationError then "Error parsing JSON, JSON does not conform to schema"
      else T.absurd(self)
      end
    end

    sig { returns(StandardError) }
    def error
      case self
      when JSONParseError then JSONParseException.new
      when JSONValidationError then JSONValidationException.new
      else T.absurd(self)
      end
    end
  end

  # A class representing the allowed params into the `submit_media_review` endpoint
  class SubmitReviewParams < T::Struct
    const :review_json, String
  end

  # A class representing the allowed params into the `submit_media_review_source` endpoint
  class SubmitReviewSourceParams < T::Struct
    const :url, String
  end


  # Creates a MediaReview and ArchiveItem based on a POSTed MediaReview JSON object
  #
  #  @params {media_review_json} A MediaReview JSON object
  sig { void }
  def submit_review
    # TODO: Spin off an active job to handle this
    typed_params = TypedParams[SubmitReviewParams].new.extract!(params)
    review_json = JSON.parse(typed_params.review_json)

    raise ApiErrors::JSONValidationError.error unless review_json.key?("@type")

    case review_json["@type"]
    when "ClaimReview"
      response_payload = archive_from_claim_review(review_json)
    when "MediaReview"
      response_payload = archive_from_media_review(review_json)
    else
      raise ApiErrors::JSONValidationException
    end

    render(json: response_payload, status: response_payload.has_key?(:error) ? 400 : 200)
  rescue JSON::ParserError
    response_payload = {
      error_code: ApiErrors::JSONParseError.code,
      error: ApiErrors::JSONParseError.message,
      failures: review_json
    }
    render(json: response_payload, status: 400)
  rescue ApiErrors::JSONValidationException
    response_payload = {
      error_code: ApiErrors::JSONValidationError.code,
      error: ApiErrors::JSONValidationError.message,
      failures: review_json
    }
    render(json: response_payload, status: 400)
  end

  # Creates MediaReview and ArchiveItem(s) based on MediaReview founded at the page pointed to by the URL param
  #
  # UNUSED!!!!!!
  sig { void }
  def submit_media_review_source
    typed_params = TypedParams[SubmitReviewSourceParams].new.extract!(params)
    mediareview_array = find_media_review_in_page(typed_params.url)

    unless mediareview_array.length.positive?
      failure_response = {
        response_code: 40,
        response: "Could not find MediaReview in webpage"
      }
      render(json: failure_response, status: 400)
      return
    end

    # Archive items
    responses = mediareview_array.each do |review|
      archive_from_media_review review
    end

    archive_success = responses.all? { |response| !response.has_key?(:error) }
    if archive_success
      success_response = {
        response_code: ApiResponseCodes::Success.code,
        response: "Successfully archived #{responses.length} MediaReview object(s) and associated media"
      }
      render(json: success_response, status: 200)
      return
    end

    failure_response = {
      response_code: 40,
      response: "Failed to archive one or more MediaReview items",
      information: responses
    }
    render(json: failure_response, status: 400)

  rescue JSON::ParserError
    response_payload = {
      error_code: ApiErrors::JSONParseError.code,
      error: ApiErrors::JSONParseError.message,
      failures: media_review_json
    }
    render(json: response_payload, status: 400)
  rescue ApiErrors::JSONValidationException
    response_payload = {
      error_code: ApiErrors::JSONValidationError.code,
      error: ApiErrors::JSONValidationError.message,
      failures: media_review_json
    }
    render(json: response_payload, status: 400)
  end

  # Finds MediaReview JSON objects embedded in <script> tags at the page pointed to by the url param
  #
  # @param [String] url: the url to look at
  # @return An array of MediaReview hashes
  #
  #
  #
  # # UNUSED!!!!!!
  sig { params(url: String).returns(T::Array[Hash]) }
  def find_media_review_in_page(url)
    mediareview_javascript = /<script.*?>(\[.*MediaReview.*\]).*<\/script>/

    response = Typhoeus.get url
    if response.response_code != 200
      return []
    end
    body = response.body

    mediareview_string = body.match mediareview_javascript
    return [] unless mediareview_string

    mediareview_array = mediareview_string.captures.first
    JSON.parse mediareview_array
  end

  # Creates an ArchiveItem and MediaReview object based on a MediaReview hash
  # @param [Hash] media_review_json: A MediaReview hash object
  # @return [Hash]: A hash containing response codes and a reference to the newly created ArchiveItem
  sig { params(media_review_json: Hash).returns(Hash) }
  def archive_from_media_review(media_review_json)
    return {
      error_code: ApiErrors::JSONValidationError.code,
      error: ApiErrors::JSONValidationError.message,
      failures: media_review_json
    } unless validate_media_review(media_review_json)

    saved_object = ArchiveItem.create_from_media_review(media_review_json)

    {
      response_code: ApiResponseCodes::Success.code,
      response: ApiResponseCodes::Success.message,
      media_object_id: saved_object.id
    }
  end

  # Creates a ClaimReview object based on a ClaimReview hash
  # @param [Hash] media_review_json: A MediaReview hash object
  # @return [Hash]: A hash containing response codes and a reference to the newly created ArchiveItem
  sig { params(claim_review_json: Hash).returns(Hash) }
  def archive_from_claim_review(claim_review_json)
    return {
      error_code: ApiErrors::JSONValidationError.code,
      error: ApiErrors::JSONValidationError.message,
      failures: claim_review_json
    } unless validate_claim_review(claim_review_json)

    saved_object = ClaimReview.create!(
      date_published: claim_review_json["datePublished"],
      url: claim_review_json["url"],
      author: claim_review_json["author"],
      claim_reviewed: claim_review_json["claimReviewed"],
      review_rating: claim_review_json["reviewRating"],
      item_reviewed: claim_review_json["itemReviewed"],
    )

    {
      response_code: ApiResponseCodes::Success.code,
      response: ApiResponseCodes::Success.message,
      claim_review_id: saved_object.id
    }
  end

private

  # Validate MediaReview that was passed in
  sig { params(media_review: Hash).returns(T::Boolean) }
  def validate_media_review(media_review)
    schema = File.open("public/json-schemas/media-review-schema.json").read
    JSONSchemer.schema(schema).valid?(media_review)
  rescue StandardError
    false
  end

  # Validate MediaReview that was passed in
  sig { params(claim_review: Hash).returns(T.any(T::Boolean, Array)) }
  def validate_claim_review(claim_review)
    schema = File.open("public/json-schemas/claim-review-schema.json").read
    if JSONSchemer.schema(schema).valid?(claim_review)
      true
    else
      JSONSchemer.schema(schema).validate(claim_review).map { |error| error.slice("data", "data_pointer", "type") }
    end
  rescue StandardError
    false
  end
end
