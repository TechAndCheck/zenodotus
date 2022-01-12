class OrganizationsController < ApplicationController
  before_action :authenticate_user!, :setup_variables
  before_action :authenticate_ability_to_edit!, except: [:index]

  # Displays the current organization the user belongs to
  # TODO: Add a path for super admins that lists all orgs instead
  def index; end

  def new; end

  def create; end

  def edit; end

  def delete; end

  # Only available to super admins
  def list; end

  def update_admin
    organization = Organization.find(params[:organization_id])
    user = User.find(params[:user_id])

    raise "User must belong to an organization to be an admin" unless organization.users.include? user

    organization.update!({ admin: user })
    redirect_to action: :index
  end

private

  def setup_variables
    @organization = current_user.organization
  end

  def authenticate_organization_admin
    current_user.organization.admin == current_user
  end

  def authenticate_organization_admin!
    redirect_to "/" unless authenticate_organization_admin
  end

  def authenticate_ability_to_edit
    authenticate_super_user || authenticate_organization_admin
  end

  def authenticate_ability_to_edit!
    redirect_to "/" unless authenticate_ability_to_edit
  end
end
