# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :check_for_login_and_remote_token, only: [:new]
  before_action :must_be_logged_out, only: [:new]
  before_action :authenticate_user_and_setup!, except: [:create]

  # An error for use when validating MFA tokens for login
  class MFAValidationError < StandardError; end

  class FinishWebauthnValidationParams < T::Struct
    const :publicKeyCredential, Hash
  end

  class FinishTotpValidationParams < T::Struct
    const :totpCode, String
  end

  class FinishRecoverCodeValidationParams < T::Struct
    const :recoveryCode, String
  end

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  # We patch this so that instead of logging the user in we check that they exist and then move to the 2FA page
  def create
    user = User.find_for_authentication(email: params["user"][:email].downcase)

    # This will redirect back to the login page and handle flashes and such if it's invalid
    warden.authenticate!(auth_options) if user.nil? || !user.valid_password?(params["user"][:password])

    # If the user doesn't have MFA setup we flush them over to the setup
    unless user.mfa_enabled?
      flash[:notice] = "You must setup MFA before you can login"

      # We have to log the user in before they set up MFA
      # I'm hoping that this doesn't open up any security issues, but this shouldn't appear unless
      # it's authenticated in the lines above anyways
      sign_in(user)
      redirect_to(account_setup_mfa_path) && return
    end

    # Set the user to the session for just the next step
    session[:mfa_validate_user] = user.id

    redirect_to mfa_validation_path
    # super
  end

  # GET /resource/sign_in/mfa
  def mfa_validation
    # Get the user from the session or go bye bye
    user_id = session[:mfa_validate_user]
    raise MFAValidationError if user_id.nil?

    @user = User.find(user_id)
    raise MFAValidationError if @user.nil?
    @page_metadata = { title: "Login", description: "Login" }
  rescue MFAValidationError
    flash[:notice] = "You do not have access to the previous page"
    redirect_to new_user_session_path
  end

  # POST /resource/sign_in/mfa/totp
  def finish_mfa_totp_validation
    # Get the user from the session or go bye bye
    user_id = session[:mfa_validate_user]
    raise MFAValidationError if user_id.nil?

    user = User.find(user_id)
    raise MFAValidationError if user.nil?

    typed_params = OpenStruct.new(params)

    raise MFAValidationError unless user.validate_totp_login_code(typed_params.totpCode)
    sign_in(user)

    respond_to do |format|
      format.json { render json: { authentication_status: "success" } }
    end
  rescue MFAValidationError
    # If validation failed
    respond_to do |format|
      format.json {
        render json: {
          errorPartial:
            render_to_string(
              partial: "accounts/setup_mfa_error",
              formats: :html,
              layout: false,
              locals: { error: "Invalid or expired TOTP code, check your app and try again" }
            )
        }
      }
    end
  end

  # GET /resource/sign_in/mfa/webauthn
  def begin_mfa_webauthn_validation
    # Get the user from the session or go bye bye
    user_id = session[:mfa_validate_user]
    raise MFAValidationError if user_id.nil?

    user = User.find(user_id)
    raise MFAValidationError if user.nil?

    # TODO: add types and transports
    options = relying_party(request.referer).options_for_authentication(
      allow: user.webauthn_credentials.map { |c| c.external_id }
    )

    session[:authentication_challenge] = options.challenge

    respond_to do |format|
      format.json { render json: { publicKey: options } }
    end
  rescue MFAValidationError
    flash[:notice] = "You do not have access to the previous page"
    respond_to do |format|
      format.json { render json: { error: "There's been an error validating credentials. Please log out and try again." } }
    end
  end

  def finish_mfa_webauthn_validation
    # The reason this is an OpenStruct is to easily migrated from old TypedParams style
    # TODO: Either figure out how to type it or just use regular hash params
    typed_params = OpenStruct.new(params)

    webauthn_credential = WebAuthn::Credential.from_get(typed_params.publicKeyCredential)

    user_id = session[:mfa_validate_user]
    raise MFAValidationError if user_id.nil?

    user = User.find(user_id)
    raise MFAValidationError if user.nil?

    credential_index = user.webauthn_credentials.find_index { |cred| cred.external_id == webauthn_credential.id }
    raise MFAValidationError if credential_index.nil?

    stored_credential = user.webauthn_credentials[credential_index]

    begin
      relying_party(request.referer).verify_authentication(
        typed_params.publicKeyCredential,
        session[:authentication_challenge],
        public_key: stored_credential.public_key,
        sign_count: stored_credential.sign_count,
      )

      # Update the stored credential sign count with the value from `webauthn_credential.sign_count`
      stored_credential.update!(sign_count: webauthn_credential.sign_count)

      # Continue with successful sign in or 2FA verification...
      sign_in(user)

      if session[:token]
        render json: {
                authentication_status: "success",
                redirect: remote_token_path # The token is rotated when the page is visited
        }
      else
        respond_to do |format|
          format.json { render json: { authentication_status: "success" } }
        end
      end
    rescue WebAuthn::SignCountVerificationError => e
      # Cryptographic verification of the authenticator data succeeded, but the signature counter was less then or equal
      # to the stored value. This can have several reasons and depending on your risk tolerance you can choose to fail or
      # pass authentication. For more information see https://www.w3.org/TR/webauthn/#sign-counter
      respond_to do |format|
        render json: {
          errorPartial:
            render_to_string(
              partial: "accounts/setup_mfa_error",
              formats: :html,
              layout: false,
              locals: { error: e }
            )
        }
      end
    rescue WebAuthn::Error => e
      respond_to do |format|
        render json: {
          errorPartial:
            render_to_string(
              partial: "accounts/setup_mfa_error",
              formats: :html,
              layout: false,
              locals: { error: e }
            )
        }
      end
    end
  end

  def mfa_use_recovery_code
    # Get the user from the session or go bye bye
    user_id = session[:mfa_validate_user]
    raise MFAValidationError if user_id.nil?

    user = User.find(user_id)
    raise MFAValidationError if user.nil?
  rescue MFAValidationError
    flash[:notice] = "You do not have access to the previous page"
    redirect_to new_user_session_path
  end

  def mfa_validate_recovery_code
    typed_params = OpenStruct.new(params)

    # Get the user from the session or go bye bye
    user_id = session[:mfa_validate_user]
    raise MFAValidationError if user_id.nil?

    user = User.find(user_id)
    raise MFAValidationError if user.nil?

    # Validate the recovery code
    raise MFAValidationError unless user.validate_recovery_code(typed_params.recoveryCode)

    sign_in(user)

    flash[:notice] = "You have successfully logged in with a recovery code, if you have lost your device please setup a new one in settings"
    respond_to do |format|
      format.json { render json: { authentication_status: "success" } }
    end
  rescue MFAValidationError
    flash[:notice] = "Invalid recovery code."
    respond_to do |format|
      format.json {
        render json: {
          errorPartial:
            render_to_string(
              partial: "accounts/use_recovery_code_error",
              formats: :html,
              layout: false,
            )
        }
      }
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
