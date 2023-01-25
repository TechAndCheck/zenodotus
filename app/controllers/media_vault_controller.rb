# typed: strict

class MediaVaultController < ApplicationController
  before_action :authenticate_user_and_setup!, except: [
    :terms,
    :privacy,
    :optout,
  ]
  before_action :must_be_media_vault_user, except: [
    :terms,
    :privacy,
    :optout,
  ]

  # We don't route to this URL directly.
  # Instead, `application#index` renders its template without a redirect.
  sig { void }
  def index; end

  sig { void }
  def guide; end

  sig { void }
  def terms; end

  sig { void }
  def privacy; end

  sig { void }
  def optout; end

protected

  sig { void }
  def must_be_media_vault_user
    unless current_user && current_user.can_access_media_vault?
      respond_to do |format|
        format.html do
          redirect_back_or_to after_sign_in_path_for(current_user), allow_other_host: false, flash: { error: "You are not authorized to access that resource." }
        end
        format.turbo_stream do
          flash.now[:error] = "You are not authorized to access that resource."
          render turbo_stream: [
            turbo_stream.replace("flash", partial: "layouts/flashes/turbo_flashes", locals: { flash: flash }),
          ]
        end
        format.json do
          render json: {
            error: "You are not authorized to access that resource."
          }, status: :unauthorized
        end
      end
    end
  end
end
