class ApplicantsController < ApplicationController
  before_action :must_be_logged_out

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
      OpenStruct.new(applicant_params)
    rescue ActionController::BadRequest
      @applicant = Applicant.new # Needed for form rendering
      generic_create_error && return
    end

    decorated_params = applicant_params.merge({
      # Record what site the visitor is applying from
      source_site: get_site_from_host[:shortname],
      # Add the confirmation token the applicant uses to confirm their email address
      confirmation_token: Devise.friendly_token,
    })
    decorated_params[:email] = decorated_params[:email]&.downcase

    @applicant = Applicant.new(decorated_params)

    existing_user = User.readonly.find_by(email: @applicant[:email]&.downcase)
    # We intentionally return a generic error to avoid leaking the existence of the user.
    (generic_create_error && return) if existing_user

    begin
      @applicant.save!
    rescue ActiveRecord::RecordInvalid
      generic_create_error(status: :unprocessable_entity) && return
    end

    send_confirmation_email

    redirect_to applicant_confirmation_sent_path
  end

  sig { void }
  def confirmation_sent; end

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
      OpenStruct.new(confirm_params)
    rescue ActionController::BadRequest
      render(:confirmation_not_found, status: :bad_request) && return
    end

    @applicant = Applicant.find_by_email_and_token(
      email: confirm_params[:email],
      token: confirm_params[:token]
    )
    (render(:confirmation_not_found, status: :not_found) && return) unless @applicant.present?

    unless @applicant.confirmed?
      @applicant.confirm
      (render(:confirmation_error, status: :internal_server_error) && return) unless @applicant.confirmed?
    end

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

  # This method renders a generic response that the creation failed.
  #
  # This response is intentionally vague and used in multiple scenarios, as one of those scenarios
  # is when someone applies with an email address linked to an existing *user* (not applicant). We
  # want to prevent this from happening without leaking the existence of the user account.
  sig { params(status: Symbol).returns(String) }
  def generic_create_error(status: :bad_request)
    flash.now[:error] = "We were unable to save your application. Please check the form for errors and try again, or contact us for help."
    render :new, status: status
  end

  sig { void }
  def send_confirmation_email
    @applicant.send_confirmation_email(@site)
  end
end
