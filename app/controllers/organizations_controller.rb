class OrganizationsController < ApplicationController
  before_action :authenticate_user!, :setup_variables
  before_action :authenticate_super_user, except: [:index]

  # before_action :verify_member!

  # Displays the current organization the user belongs to
  # TODO: Add a path for super admins that lists all orgs instead
  def index; end

  def new; end

  def create; end

  def edit; end

  def delete; end

  # Only available to super admins
  def list; end

private

  def setup_variables
    @organization = current_user.organization
  end

  # Check if a user is a member of this organization, redirect out if not
  # def verify_member!
  #   unless current_user && current_user.organization.users.include?(current_user)
  #     redirect_back_or_to "/", allow_other_host: false, alert: "You must be a member of #{@organization.name} to view this page."
  #   end
  # end
end
