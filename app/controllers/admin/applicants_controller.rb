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
    typed_params = OpenStruct.new(params)
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

    begin
      @applicant.approve(
        reviewer: current_user,
        review_note: review_params[:review_note],
        review_note_internal: review_params[:review_note_internal],
      )
    rescue Applicant::UnconfirmedError
      flash[:error] = "Applicant has not confirmed their email address."
      return redirect_to admin_applicants_path, status: :precondition_failed
    end

    user = User.create_from_applicant(@applicant)
    user.send_setup_instructions

    flash[:success] = "Applicant has been approved."
    redirect_to admin_applicants_path
  end

  sig { void }
  def reject
    @applicant = Applicant.find(review_params[:id])

    begin
      @applicant.reject(
        reviewer: current_user,
        review_note: review_params[:review_note],
        review_note_internal: review_params[:review_note_internal],
      )
    rescue Applicant::StatusChangeError
      flash[:error] = "Applicant has already been approved."
      return redirect_to admin_applicants_path, status: :precondition_failed
    end

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
