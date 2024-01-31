# typed: strict

class Admin::ApplicantsController < AdminController
  sig { void }
  def index
    @unreviewed_applicants = Applicant.unreviewed.order(created_at: :desc)
    @reviewed_applicants = Applicant.reviewed.order(reviewed_at: :desc)
  end

  sig { void }
  def show
    @applicant = Applicant.find(params[:id])
  end

  class UpdateParams < T::Struct
    const :id, String
    const :fact_check_insights_enabled, String
    const :media_vault_enabled, String
  end

  sig { void }
  def update
    typed_params = TypedParams[UpdateParams].new.extract!(params)
    user = Applicant.find(typed_params.id).user
    raise "Applicant doesn't have a user" if user.nil?

    user.remove_role(:fact_check_insights_user) if typed_params.fact_check_insights_enabled == "0"
    user.add_role(:fact_check_insights_user) if typed_params.fact_check_insights_enabled == "1"

    user.remove_role(:media_vault_user) if typed_params.media_vault_enabled == "0"
    user.add_role(:media_vault_user) if typed_params.media_vault_enabled == "1"
  end

  sig { void }
  def approve
    @applicant = Applicant.find(review_params[:id])

    @applicant.approve(
      reviewer: current_user,
      review_note: review_params[:review_note],
      review_note_internal: review_params[:review_note_internal],
    )

    user = User.create_from_applicant(@applicant)
    user.send_setup_instructions

    flash[:success] = "Applicant has been approved."
    redirect_to admin_applicants_path
  end

  sig { void }
  def reject
    @applicant = Applicant.find(review_params[:id])

    @applicant.reject(
      reviewer: current_user,
      review_note: review_params[:review_note],
      review_note_internal: review_params[:review_note_internal],
    )

    flash[:success] = "Applicant has been rejected."
    redirect_to admin_applicants_path
  end

  sig { void }
  def delete
    @applicant = Applicant.find(review_params[:id])

    @applicant.delete

    flash[:success] = "Applicant has been deleted."
    redirect_to admin_applicants_path
  end

private

  def review_params
    params.permit(
      :id,
      :review_note,
      :review_note_internal,
    )
  end
end
