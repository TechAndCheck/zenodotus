# typed: strict
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

  sig { void }
  def update_admin
    organization = Organization.find(params[:organization_id])
    user = User.find(params[:user_id])

    raise "User must belong to an organization to be an admin" unless organization.users.include? user

    organization.update!({ admin: user })
    redirect_to action: :index
  end

  sig { void }
  def delete_user
    organization = Organization.find(params[:organization_id])
    user = User.find(params[:user_id])

    if user == current_user
      flash[:alert] = "You cannot delete yourself"
      redirect_to action: :index
      return
    end

    raise "User must belong to an organization to be an admin" unless organization.users.include? user

    begin
      user.destroy!
    rescue User::DontDestroyIfAdminError => e
      flash[:alert] = e.message
    end

    redirect_to action: :index
  end

  private

    sig { void }
    def setup_variables
      @organization = current_user.organization
    end

    sig { returns(T::Boolean) }
    def authenticate_organization_admin
      current_user.organization.admin == current_user
    end

    sig { void }
    def authenticate_organization_admin!
      redirect_to "/" unless authenticate_organization_admin
    end

    sig { returns(T::Boolean) }
    def authenticate_ability_to_edit
      authenticate_super_user || authenticate_organization_admin
    end

    sig { void }
    def authenticate_ability_to_edit!
      redirect_to "/" unless authenticate_ability_to_edit
    end
end
