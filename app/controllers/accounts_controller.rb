# frozen_string_literal: true

# typed: strict

class AccountsController < ApplicationController
  class InvalidTokenError < StandardError; end
  class InvalidUpdatePasswordError < StandardError; end

  rescue_from InvalidTokenError, with: :invalid_token_error
  rescue_from InvalidUpdatePasswordError, with: :invalid_update_password_error

  before_action :authenticate_user!, except: [
    :new,
    :create,
    :reset_password,
    :send_password_reset_email,
  ]

  before_action :must_be_logged_out, only: [
    :new,
    :create,
    :reset_password,
    :send_password_reset_email,
  ]

  sig { void }
  def index
    @pagy_text_searches, @text_searches = pagy(TextSearch.where(user: current_user).order("created_at DESC"), page_param: :text_search_page, items: 10)
    @pagy_image_searches, @image_searches = pagy(ImageSearch.where(user: current_user).order("created_at DESC"), page_param: :image_search_page, items: 7)
  end

  # A class representing the allowed params into the `change_password` endpoint
  class ChangePasswordParams < T::Struct
    const :password, String
    const :confirmed_password, String
  end

  class ChangeEmailParams < T::Struct
    const :email, String
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
      typed_params = TypedParams[SetupAccountParams].new.extract!(params)
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
    typed_params = TypedParams[CreateAccountParams].new.extract!(params)

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
    # From here branch to set up 2FA
    redirect_to account_setup_mfa_path
  end

  sig { void }
  def setup_mfa
    ######
    # TODO: Next steps:
    # - Make sure the route above works to get to here
    #   do this via the console after creating an applicant in the UI
    #   Then `applicant.approve` and User.create_from_applicant(applicant)
    # - From here refer to https://www.honeybadger.io/blog/multi-factor-2fa-authentication-rails-webauthn-devise/
    #   and https://github.com/cedarcode/webauthn-ruby
    #   This could be used later too https://github.com/github/webauthn-json
    current_user.remove_role :new_user
  end

  sig { void }
  def start_webauthn_setup
    if !current_user.webauthn_id
      current_user.update!(webauthn_id: WebAuthn.generate_user_id)
    end

    options = WebAuthn::Credential.options_for_create(
      user: { id: current_user.webauthn_id, display_name: current_user.email, name: current_user.email },
      rp: { name: current_user.email },
      exclude: current_user.webauthn_credentials.pluck(:external_id)
    )

    # Store the newly generated challenge somewhere so you can have it
    # for the verification phase.
    session[:webauthn_credential_register_challenge] = options.challenge

    # Send `options` back to the browser, so that they can be used
    # to call `navigator.credentials.create({ "publicKey": options })`
    #
    # You can call `options.as_json` to get a ruby hash with a JSON representation if needed.

    # If inside a Rails controller, `render json: options` will just work.
    # I.e. it will encode and convert the options to JSON automatically.

    # For your frontend code, you might find @github/webauthn-json npm package useful.
    # Especially for handling the necessary decoding of the options, and sending the
    # `PublicKeyCredential` object back to the server.

    options = { publicKey: options }

    # redirect_to after_sign_in_path_for(current_user)
    respond_to do |format|
      format.json { render json: options }
    end
  end

  sig { void }
  def finish_webauthn_setup
    typed_params = TypedParams[FinishWebauthnSetupParams].new.extract!(params)

    webauthn_credential = WebAuthn::Credential.from_create(typed_params.publicKeyCredential)

    begin
      webauthn_credential.verify(session[:webauthn_credential_register_challenge])

      # The validation would raise WebAuthn::Error so if we are here, the credentials are valid, and we can save it
      credential = current_user.webauthn_credentials.new(
          external_id: webauthn_credential.id,
          public_key: webauthn_credential.public_key,
          nickname: typed_params.nickname,
          sign_count: webauthn_credential.sign_count
        )

      if credential.save
        render json: { registration_status: "success" }
      else
        render json: { registration_status: "error", error: "Unknown processing error" }
      end
    rescue WebAuthn::Error => e
      render json: { registration_status: "error", error: e }
    ensure
      session.delete(:webauthn_credential_register_challenge)
    end
  end

  sig { void }
  def send_password_reset_email
    typed_params = TypedParams[ResetPasswordParams].new.extract!(params)
    email = typed_params.email
    @user = User.find_by(email: email)
    @user.send_reset_password_instructions unless @user.nil?
    redirect_to "/users/sign_in", notice: "A recovery email has been sent to the provided email addres "
  end

  sig { void }
  def reset_password
  end

  sig { void }
  def change_password
    typed_params = TypedParams[ChangePasswordParams].new.extract!(params)

    current_user.reset_password(typed_params.password, typed_params.confirmed_password)
    # For some reason, despite having the settings correct, changing the password logs the user out
    # This logs them straight back in
    bypass_sign_in(current_user)

    respond_to do |format|
      if typed_params.password != typed_params.confirmed_password
        flash.now[:alert] = "Passwords did not match. Please try again."
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
    typed_params = TypedParams[ChangeEmailParams].new.extract!(params)
    current_user.email = typed_params.email
    current_user.save
    respond_to do |format|
      flash.now[:alert] = "We just sent a confirmation message to the email address you provided. Please check your inbox and follow the confirmation link in the message."
      format.turbo_stream { render turbo_stream: [
        turbo_stream.replace("flash", partial: "layouts/flashes/turbo_flashes", locals: { flash: flash }),
      ] }
    end
  end

  sig { void }
  def destroy
    user = User.find(params[:user])
    user.destroy
    redirect_to "/users/sign_in"
  end

  sig { void }
  def admin; end

private

  def invalid_token_error
    render "status/accounts/invalid_token", status: :bad_request
  end

  def invalid_update_password_error
    flash.now[:error] = "We were unable to setup your account. Please check the form for errors and try again, or contact us for help."
    render "new", status: :bad_request
  end
end
