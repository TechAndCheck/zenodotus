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

  sig { void }
  def approve
    @applicant = Applicant.find(review_params[:id])

    @applicant.approve(
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
      review_note: review_params[:review_note],
      review_note_internal: review_params[:review_note_internal],
    )

    flash[:success] = "Applicant has been rejected."
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
