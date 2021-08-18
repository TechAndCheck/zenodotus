# typed: ignore

class IngestController < ApplicationController
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
  end

  # A class representing the allowed params into the `submit_media_review` endpoint
  class SubmitMediaReviewParams < T::Struct
    const :media_review_json, String
  end

  # Submit MediaReview data, which the URL will be scraped from
  sig { void }
  def submit_media_review
    # byebug
    # TODO: Spin off an active job to handle this
    typed_params = TypedParams[SubmitMediaReviewParams].new.extract!(params)
    media_review_json = JSON.parse(typed_params.media_review_json)

    unless validate_media_review(media_review_json)
      error = {
        error_code: ApiErrors::JSONValidationError.code,
        error: ApiErrors::JSONValidationError.message,
        information: "" }
      render(json: error, status: 400) && return
    end

    saved_object = ArchiveItem.create_from_media_review(media_review_json)
    response = {
      response_code: ApiResponseCodes::Success.code,
      response: ApiResponseCodes::Success.message,
      media_object_id: saved_object.id
    }

    render json: response, status: 200
  rescue JSON::ParserError
    error = {
      error_code: ApiErrors::JSONParseError.code,
      error: ApiErrors::JSONParseError.message,
      information: "" }
    render(json: error, status: 400)
  end

private

  # Validate MediaReview that was passed in
  sig { params(media_review: Hash).returns(T::Boolean) }
  def validate_media_review(media_review)
    schema = File.open("public/json-schemas/claim-review-schema.json").read
    JSONSchemer.schema(schema).valid?(media_review)
  rescue StandardError
    false
  end
end
