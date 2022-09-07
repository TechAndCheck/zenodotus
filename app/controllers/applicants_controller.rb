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

  # A class representing the allowed params into the `confirm` endpoint
  class ConfirmApplicantEmailParams < T::Struct
    const :email, String
    const :token, String
  end

  # Look up and confirm an unconfirmed `Applicant` using an email and token pair.
  #
  # In all failure cases we redirect to an intentionally-ambiguous "confirmation not found" page,
  # whether because a parameter is missing or we can't match them to an unconfirmed applicant. This
  # is because we don't want to implicitly reveal the existence or status of any other applicant.
  sig { void }
  def confirm
    begin
      # Verify the types of the values provided in the request.
      # TODO: Actually use the output of this, if possible.
      TypedParams[ConfirmApplicantEmailParams].new.extract!(confirm_params)
    rescue ActionController::BadRequest
      return render :confirmation_not_found, status: :bad_request
    end

    @applicant = Applicant.find_unconfirmed_by_email_and_token(
      email: confirm_params[:email],
      token: confirm_params[:token]
    )
    return render :confirmation_not_found, status: :not_found unless @applicant.present?

    @applicant.confirm
    return render :confirmation_error, status: :internal_server_error unless @applicant.confirmed?

    # TODO: Notify admins of a pending application here (#273).

    redirect_to applicant_confirmed_path
  end

  # Renders an intentionally-ambiguous message about the confirmation not being found. Used in
  # multiple error cases when prefer to neither confirm nor deny the existence of a specific email
  # address or applicant.
  sig { void }
  def confirmation_not_found; end

  # Renders an error that the confirmation could not be completed.
  sig { void }
  def confirmation_error; end

  # Renders a message that the confirmation was successful.
  sig { void }
  def confirmed; end

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

  def confirm_params
    params.permit(
      :email,
      :token
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
