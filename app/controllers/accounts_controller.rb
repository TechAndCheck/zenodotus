# frozen_string_literal: true

# typed: strict

class AccountsController < ApplicationController
  class InvalidTokenError < StandardError; end
  class InvalidUpdatePasswordError < StandardError; end

  rescue_from InvalidTokenError, with: :invalid_token_error
  rescue_from InvalidUpdatePasswordError, with: :invalid_update_password_error

  before_action :authenticate_stub, only: [
    :setup_mfa,
    :start_webauthn_setup,
    :finish_webauthn_setup,
    :start_totp_setup,
    :finish_totp_setup,
    :clear_mfa,
  ]

  before_action :authenticate_user_and_setup!, except: [
    :new,
    :create,
    :reset_password,
    :send_password_reset_email,
    :setup_mfa,
    :start_webauthn_setup,
    :finish_webauthn_setup,
    :start_totp_setup,
    :finish_totp_setup,
    :clear_mfa,
  ]

  before_action :must_be_logged_out, only: [
    :new,
    :create,
    :reset_password,
    :send_password_reset_email,
  ]

  sig { void }
  def index
    @pagy_text_searches, @text_searches = pagy(TextSearch.where(user: current_user).order("created_at DESC"), page_param: :text_search_page, items: 50)
    @pagy_image_searches, @image_searches = pagy(ImageSearch.where(user: current_user).order("created_at DESC"), page_param: :image_search_page, items: 20)
  end

  # A class representing the allowed params into the `change_password` endpoint
  class ChangePasswordParams < T::Struct
    const :password, String
    const :password_confirmation, String
  end

  class ChangeEmailParams < T::Struct
    const :email, String
    const :email_confirmation, String
  end

  class DeleteMFADeviceParams < T::Struct
    const :device_id, String
  end

  class DestroyAccountParams < T::Struct
    const :password_for_deletion, String
  end

  class SetupAccountParams < T::Struct
    const :token, String
  end

  class CreateAccountParams < T::Struct
    const :reset_password_token, String
    const :password, String
    const :password_confirmation, String
  end

  class ResetPasswordParams < T::Struct
    const :email, String
  end

  class FinishWebauthnSetupParams < T::Struct
    const :nickname, String
    const :publicKeyCredential, Hash
  end

  sig { void }
  def new
    begin
      typed_params = OpenStruct.new(params)
    rescue ActionController::BadRequest
      raise InvalidTokenError
    end

    # Public token generated by Devise::Recoverable
    @reset_password_token = typed_params.token
    @user = User.with_reset_password_token(@reset_password_token)

    raise InvalidTokenError if @user.nil?
  end

  sig { void }
  def create
    typed_params = OpenStruct.new(params)

    @reset_password_token = typed_params.reset_password_token
    @user = User.reset_password_by_token({
      reset_password_token: typed_params.reset_password_token,
      password: typed_params.password,
      password_confirmation: typed_params.password_confirmation
    })

    # This bit is a little tricky and relies on knowledge of Devise::Recoverable's internals.
    # `Devise::Recoverable.reset_password_by_token` finds the user with that token, updates their
    # password, and deletes their token. However, the return values are all over the map:
    #
    # - If it succeeds in finding and updating the user, it returns the user in a valid state.
    # - If it succeeds in finding the user but fails in updating it, it returns the user in an
    #   invalid state. `invalid?` catches this.
    # - If it fails to find the user, it returns an empty User. While `invalid?` would catch this,
    #   we use `new_record?` in order to be more explicit.
    #
    # This would be sufficient, except that obnoxiously, blank passwords *don't* trip it up, even
    # though `Devise::Recoverable#reset_password`, which `reset_password_by_token` uses, seems to
    # handle that and put the model into an invalid state. Thus, we also have the `blank?` check.
    raise InvalidTokenError if @user.new_record?
    raise InvalidUpdatePasswordError if typed_params.password.blank? || @user.invalid?

    sign_in @user
    current_user.remove_role :new_user
    # From here branch to set up 2FA
    redirect_to account_setup_mfa_path
  end

  sig { void }
  def setup_mfa; end

  sig { void }
  def start_totp_setup
    totp_provisioning_uri = current_user.generate_totp_provisioning_uri
    totp_qr = RQRCode::QRCode.new(totp_provisioning_uri)

    totp_qr_png = Base64.encode64(totp_qr.as_png(size: 400).to_blob)

    render json: {
          partial:
            render_to_string(
              partial: "accounts/start_totp_setup",
              formats: :html,
              layout: false,
              locals: { totp_qr_png: totp_qr_png }
            )
        }
  end

  sig { void }
  def finish_totp_setup
    if current_user.validate_totp_login_code(params[:totp_setup_code])
      current_user.update!({ totp_confirmed: true })
      render json: { registration_status: "success" } && return
    end

    render json: {
      errorPartial:
        render_to_string(
          partial: "accounts/setup_mfa_error",
          formats: :html,
          layout: false,
          locals: { error: "Invalid TOTP authentication code. Please try again" }
        )
    }
  end

  sig { void }
  def start_webauthn_setup
    if !current_user.webauthn_id
      current_user.update!(webauthn_id: WebAuthn.generate_user_id)
    end

    options = relying_party(request.referer).options_for_registration(
      user: { id: current_user.webauthn_id, display_name: current_user.name, name: current_user.email },
      exclude: current_user.webauthn_credentials.pluck(:external_id)
    )

    # Store the newly generated challenge somewhere so you can have it
    # for the verification phase.
    session[:webauthn_credential_register_challenge] = options.challenge
    options = { publicKey: options }

    respond_to do |format|
      format.json { render json: options }
    end
  end

  sig { void }
  def finish_webauthn_setup
    typed_params = OpenStruct.new(params)

    begin
      begin
        webauthn_credential = relying_party(request.referer).verify_registration(typed_params.publicKeyCredential, session[:webauthn_credential_register_challenge])
      rescue WebAuthn::OriginVerificationError
        logger.warn("***********************************")
        logger.warn("Error setting up webauthn: Origin verification failed")
        logger.warn("Requested origin: #{request.referrer}")
        logger.warn("Allowed origin: #{ENV["AUTH_BASE_HOST"]}")
        logger.warn("User: #{current_user.email}")
        logger.warn("Time: #{Time.now}")
        logger.warn("***********************************")

        render json: {
          errorPartial:
            render_to_string(
              partial: "accounts/setup_mfa_error",
              formats: :html,
              layout: false,
              locals: { error: "Error validating credentials: Origin mismatch. Please contact us when you receive this message with timestamp #{Time.now}." }
            )
        }
        return

      rescue StandardError => e
        logger.warn("***********************************")
        logger.warn("Error setting up webauthn: #{e}")
        logger.warn("User: #{current_user.email}")
        logger.warn("Time: #{Time.now}")
        logger.warn("***********************************")

        render json: {
          errorPartial:
            render_to_string(
              partial: "accounts/setup_mfa_error",
              formats: :html,
              layout: false,
              locals: { error: "Error validating credentials, please contact us if you continue to have problems." }
            )
        }
        return
      end

      # The validation would raise WebAuthn::Error so if we are here, the credentials are valid, and we can save it
      # TODO: Add "type" to this
      credential = current_user.webauthn_credentials.new(
          external_id: webauthn_credential.id,
          public_key: webauthn_credential.public_key,
          nickname: typed_params.nickname,
          sign_count: webauthn_credential.sign_count,
          key_type: webauthn_credential.type,
        )

      if credential.save
        render json: { registration_status: "success" }

      else
        render json: {
          errorPartial:
            render_to_string(
              partial: "accounts/setup_mfa_error",
              formats: :html,
              layout: false,
              locals: {}
            )
        }
      end
    rescue WebAuthn::Error => e
      logger.warn("***********************************")
      logger.warn("Error setting up webauthn: #{e}")
      logger.warn("User: #{current_user.email}")
      logger.warn("Time: #{Time.now}")
      logger.warn("***********************************")

      render json: {
          errorPartial:
            render_to_string(
              partial: "accounts/setup_mfa_error",
              formats: :html,
              layout: false,
              locals: { error: e }
            )
        }
    ensure
      session.delete(:webauthn_credential_register_challenge)
    end
  end

  sig { void }
  def setup_recovery_codes
    raise "Recovery codes already enabled for user." unless current_user.hashed_recovery_codes.empty?

    recovery_codes = current_user.generate_recovery_codes
    render json: {
        recoveryCodePartial:
          render_to_string(
            partial: "accounts/setup_recovery_codes",
            formats: :html,
            layout: false,
            locals: { recovery_codes: recovery_codes }
          )
      }
  rescue StandardError => e
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

  sig { void }
  def send_password_reset_email
    typed_params = OpenStruct.new(params)
    email = typed_params.email.downcase
    @user = User.find_by(email: email)
    @user.send_reset_password_instructions unless @user.nil?
    redirect_to "/users/sign_in", notice: "A recovery email has been sent to the provided email address"
  end

  sig { void }
  def reset_password
  end

  sig { void }
  def change_password
    typed_params = OpenStruct.new(params)

    current_user.reset_password(typed_params.password, typed_params.password_confirmation)
    # For some reason, despite having the settings correct, changing the password logs the user out
    # This logs them straight back in
    bypass_sign_in(current_user)

    respond_to do |format|
      if typed_params.password != typed_params.password_confirmation
        flash.now[:alert] = "Passwords did not match. Please try again."
      elsif typed_params.password.length < 6
        flash.now[:alert] = "Please use a minimum of 6 characters in your password"
      else
        flash.now[:alert] = "Password updated."
      end
      format.turbo_stream { render turbo_stream: [
        turbo_stream.replace("flash", partial: "layouts/flashes/turbo_flashes", locals: { flash: flash }),
      ] }
    end
  end

  sig { void }
  def change_email
    typed_params = OpenStruct.new(params)

    if typed_params.email.downcase != typed_params.email_confirmation.downcase
      flash.now[:alert] = "Email addresses did not match. Please try again."
    elsif URI::MailTo::EMAIL_REGEXP.match(typed_params.email).nil?
      flash.now[:alert] = "Email address was improperly formatted. Please try again."
    else
      current_user.email = typed_params.email.downcase
      current_user.save
      flash.now[:alert] = "We just sent a confirmation message to the email address you provided. Please check your inbox and follow the confirmation link in the message."
    end

    respond_to do |format|
      format.turbo_stream { render turbo_stream: [
        turbo_stream.replace("flash", partial: "layouts/flashes/turbo_flashes", locals: { flash: flash }),
      ] }
    end
  end

  sig { void }
  def destroy_mfa_device
    typed_params = OpenStruct.new(params)

    # Verify that they're not deleting the last device
    if current_user.webauthn_credentials.count == 1 && current_user.totp_confirmed == false
      flash[:error] = "You cannot delete your last MFA device. Please add another before deleting this one."
      respond_to do |format|
        format.turbo_stream { render turbo_stream: [
          turbo_stream.replace("flash", partial: "layouts/flashes/turbo_flashes", locals: { flash: flash })
        ]}
      end
      return
    end

    current_user.webauthn_credentials.find_by(id: typed_params.device_id).destroy
    flash[:alert] = "MFA device deleted."

    respond_to do |format|
      format.turbo_stream { render turbo_stream: [
        turbo_stream.replace("flash", partial: "layouts/flashes/turbo_flashes", locals: { flash: flash }),
        turbo_stream.replace("manage_mfa", partial: "accounts/manage_mfa")
      ] }
    end
  end

  sig { void }
  def destroy_totp_device
    # Verify that they're not deleting the last device
    if current_user.webauthn_credentials.count.zero? && current_user.totp_confirmed == true
      flash[:error] = "You cannot delete your last MFA device. Please add another before deleting this one."
      respond_to do |format|
        format.turbo_stream { render turbo_stream: [
          turbo_stream.replace("flash", partial: "layouts/flashes/turbo_flashes", locals: { flash: flash })
        ]}
      end
      return
    end

    current_user.clear_totp_secret
    flash[:alert] = "MFA device deleted."

    respond_to do |format|
      format.turbo_stream { render turbo_stream: [
        turbo_stream.replace("flash", partial: "layouts/flashes/turbo_flashes", locals: { flash: flash }),
        turbo_stream.replace("manage_mfa", partial: "accounts/manage_mfa")
      ] }
    end
  end


  sig { void }
  def destroy_account
    typed_params = OpenStruct.new(params)

    if current_user.valid_password?(typed_params.password_for_deletion)
      current_user.destroy
      redirect_to "/users/sign_in"
      flash[:alert] = "Your account was deleted"
    else
      flash.now[:warning] = "Incorrect password. If you would like to delete your account, please enter the corect password."
      respond_to do |format|
        format.turbo_stream { render turbo_stream: [
          turbo_stream.replace("flash", partial: "layouts/flashes/turbo_flashes", locals: { flash: flash }),
        ]}
      end
    end
  end

  sig { void }
  def admin; end

  sig { void }
  def remote_token
    @remote_token = current_user.rotate_remote_key.remote_key
  end

private

  def invalid_token_error
    render "status/accounts/invalid_token", status: :bad_request
  end

  def invalid_update_password_error
    flash.now[:error] = "We were unable to setup your account. Please check the form for errors and try again, or contact us for help."
    render "new", status: :bad_request
  end
end
