class ApplicantsController < ApplicationController
  sig { void }
  def new
    @applicant ||= Applicant.new
  end

  # A class representing the allowed params into the `create` endpoint
  class CreateApplicantParams < T::Struct
    const :name, String
    const :email, String
    const :affiliation, T.nilable(String)
    const :primary_role, T.nilable(String)
    const :use_case, T.nilable(String)
    const :accepted_terms, String
  end

  sig { void }
  def create
    # Verify the types of the values provided in the request.
    # TODO: Pass the output of this to `Applicant.create!()`
    TypedParams[CreateApplicantParams].new.extract!(applicant_params)

    @applicant = Applicant.new(applicant_params)

    if @applicant.save
      redirect_to new_applicant_thanks_path
    else
      flash.now[:error] = "We weren’t able to save your application. Please check the form below for errors."
      render :new, status: :unprocessable_entity
    end
end

  sig { void }
  def thanks; end

private

  def applicant_params
    params.require(:applicant).permit(
      :name,
      :email,
      :affiliation,
      :primary_role,
      :use_case,
      :accepted_terms
    )
  end
end
