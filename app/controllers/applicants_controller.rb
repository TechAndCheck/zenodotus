class ApplicantsController < ApplicationController
  sig { void }
  def new
    @applicant ||= Applicant.new
  end

  # A class representing the allowed params into the `create` endpoint
  class CreateApplicantParams < T::Struct
    const :name, String
    const :email, String
    const :country, T.nilable(String)
    const :affiliation, T.nilable(String)
    const :primary_role, T.nilable(String)
    const :use_case, T.nilable(String)
    const :accepted_terms, String
  end

  sig { void }
  def create
    begin
      # Verify the types of the values provided in the request.
      # TODO: Actually use the output of this, if possible.
      TypedParams[CreateApplicantParams].new.extract!(applicant_params)
    rescue ActionController::BadRequest
      flash.now[:error] = "We weren’t able to save your application. Please try again, or contact us for help."
      return render :new, status: :bad_request
    end

    # TODO: Throw an error if a user with this email exists, but without confirming existence.

    params_with_token = applicant_params.merge(confirmation_token: Devise.friendly_token)
    @applicant = Applicant.create(params_with_token)

    unless @applicant
      flash.now[:error] = "We weren’t able to save your application. Please check the form below for errors. If there are none, please contact us for help."
      return render :new, status: :unprocessable_entity
    end

    if send_confirmation_email
      redirect_to applicant_confirmation_sent_path
    else
      redirect_to applicant_confirmation_send_error_path
    end
  end

  sig { void }
  def confirmation_sent; end

  sig { void }
  def confirmation_send_error; end

private

  def applicant_params
    params.require(:applicant).permit(
      :name,
      :email,
      :country,
      :affiliation,
      :primary_role,
      :use_case,
      :accepted_terms
    )
  end

  sig { returns(T::Boolean) }
  def send_confirmation_email
    # 1. TODO: Actually send email
    sent = true

    if sent
      # This shouldn't fail but we don't particularly care if it does.
      @applicant.update(confirmation_sent_at: Time.now)
    else
      notify_of_send_confirmation_error
      return false
    end

    sent
  end

  # TODO
  sig { void }
  def notify_of_send_confirmation_error; end
end
