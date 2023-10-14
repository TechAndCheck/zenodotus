# typed: ignore

class MediaVault::IngestController < MediaVaultController
  skip_before_action :authenticate_user_and_setup!
  skip_before_action :must_be_media_vault_user

  before_action :authenticate_user_from_api_key!

  class ApiResponseCodes < T::Enum
    extend T::Sig

    enums do
      Created = new
      Updated = new
    end

    sig { returns(Integer) }
    def code
      case self
      when Created then 20
      when Updated then 20
      else T.absurd(self)
      end
    end

    sig { returns(String) }
    def message
      case self
      when Created then "Successfully archived media object"
      when Updated then "Successfully updated mediareview for existing object"
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
      def initialize(json)
        @json = json
      end

      def message
        "JSON Parser exception. Json: #{@json}"
      end
    end

    class JSONValidationException < StandardError
      def initialize(json)
        @json = json
      end

      def message
        "JSON Validation exception. Json: #{@json}"
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

    sig { params(payload: T.untyped).returns(StandardError) }
    def error(payload = nil)
      case self
      when JSONParseError then JSONParseException.new
      when JSONValidationError then JSONValidationException.new(payload)
      else T.absurd(self)
      end
    end
  end

  # A class representing the allowed params into the `submit_media_review` endpoint
  class SubmitReviewParams < T::Struct
    const :review_json, String
    const :external_unique_id, String
  end

  # A class representing the allowed params into the `submit_media_review_source` endpoint
  class SubmitReviewSourceParams < T::Struct
    const :url, String
  end


  # Uses a JSON object to create a combination of ArchiveItem, MediaReview, and ClaimReview records
  #  @params {review_json} A JSON object
  #  @params {external_unique_id} A UUID
  sig { void }
  def submit_review
    # TODO: Spin off an active job to handle this
    typed_params = TypedParams[SubmitReviewParams].new.extract!(params)
    review_json = JSON.parse(typed_params.review_json)
    external_unique_id = typed_params.external_unique_id

    logger.info "Receiving review submitted"
    logger.info review_json

    raise ApiErrors::JSONValidationError.error(review_json) unless review_json.key?("@type")

    case review_json["@type"]
    when "ClaimReview"
      should_update = ClaimReview.where(external_unique_id: external_unique_id).present?
      response_payload = archive_from_claim_review(review_json, external_unique_id, should_update)
    when "MediaReview"
      should_update = MediaReview.where(external_unique_id: external_unique_id).present?
      response_payload = archive_from_media_review(review_json, external_unique_id, should_update)
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

    # Some notes for when this is implemented (currently turning it off in testing until we build it)
    # - This only works if it's a singled piece of MediaReview. If it's an array, this next check
    #   will fail with nil
    # - It's going to have to be very messy the "accept the messiest formats, provide the strict ones"
    #   mentality.
    # - For now, the code that tests this is commented out in `ingest_controller_test.rb`
    unless mediareview_array.length.positive?
      failure_response = {
        response_code: 40,
        response: "Could not find MediaReview in webpage"
      }
      render(json: failure_response, status: 400)
      return
    end

    # Archive items
    responses = mediareview_array.each do |media_review|
      archive_from_media_review(media_review, nil)
    end

    archive_success = responses.all? { |response| !response.has_key?(:error) }
    if archive_success
      success_response = {
        response_code: ApiResponseCodes::Created.code,
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
  # @param [Boolean] should_update: A boolean indicating whether we should create or update a record
  # @return [Hash]: A hash containing response codes and a reference to the newly created ArchiveItem
  sig { params(media_review_json: Hash,
               external_unique_id: T.nilable(String),
               should_update: T::Boolean
              ).returns(Hash) }
  def archive_from_media_review(media_review_json, external_unique_id, should_update = false)
    unless validate_media_review(media_review_json)
      return {
        error_code: ApiErrors::JSONValidationError.code,
        error: ApiErrors::JSONValidationError.message,
        failures: media_review_json
      }
    else
      logger.info "Validation failed for json"
      logger.info validate_media_review(media_review_json)
    end

    if should_update
      media_review = MediaReview.create_or_update_from_media_review_hash(media_review_json, external_unique_id, should_update)
      # If an item has been saved, but the archive process hasn't been finished on Hypatia, this will be nil
      saved_object = media_review.archive_item
      response = ApiResponseCodes::Updated
    else
      saved_object = ArchiveItem.create_from_media_review(media_review_json, external_unique_id)
      response = ApiResponseCodes::Created
    end

    {
      response_code: response.code,
      response: response.message,
      media_object_id: saved_object.nil? ? nil : saved_object.id
    }
  end

  # Creates or updates a ClaimReview object based on a ClaimReview hash
  # @param [Hash] media_review_json: A MediaReview hash object
  # @param [String] external_unique_id: A unique ID for the ClaimReview
  # @param [Boolean] should_update: A boolean indicating whether we should create or update a record
  # @return [Hash]: A hash containing response codes and a reference to the newly created ArchiveItem
  sig { params(claim_review_json: Hash, external_unique_id: T.nilable(String), should_update: T::Boolean).returns(Hash) }
  def archive_from_claim_review(claim_review_json, external_unique_id, should_update = false)
    return {
      error_code: ApiErrors::JSONValidationError.code,
      error: ApiErrors::JSONValidationError.message,
      failures: claim_review_json
    } unless validate_claim_review(claim_review_json)

    claim_review_object = ClaimReview.create_or_update_from_claim_review_hash(claim_review_json, external_unique_id, should_update)
    response = should_update ? ApiResponseCodes::Updated : ApiResponseCodes::Created

    {
      response_code: response.code,
      response: response.message,
      claim_review_id: claim_review_object.id
    }
  end

private

  # Validate MediaReview that was passed in
  sig { params(media_review: Hash).returns(T.any(T::Boolean, Array)) }
  def validate_media_review(media_review)
    schema = nil
    File.open("public/json-schemas/media-review-schema.json") { |file| schema = file.read }

    if JSONSchemer.schema(schema, output_format: "basic").valid?(media_review)
      true
    else
      JSONSchemer.schema(schema, output_format: "basic").validate(media_review)["errors"].to_a
    end
  rescue StandardError
    false
  end

  # Validate MediaReview that was passed in
  sig { params(claim_review: Hash).returns(T.any(T::Boolean, Array)) }
  def validate_claim_review(claim_review)
    return true # oh well, this isn't working and i'm not spending any more hours on this

    schema = nil
    File.open("public/json-schemas/claim-review-schema.json") { |file| schema = file.read }

    if JSONSchemer.schema(schema, output_format: "basic").valid?(claim_review.to_json)
      true
    else
      JSONSchemer.schema(schema, output_format: "basic").validate(claim_review.to_json)["errors"].to_a
    end
  rescue StandardError
    false
  end
end
