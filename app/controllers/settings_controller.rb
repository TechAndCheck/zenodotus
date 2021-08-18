class SettingsController < ApplicationController
  # before_action :authenticate_user!

  def index
    puts "what's there to say?"
  end

  def approveUserRequest
    user = User.find(params[:user])
    user.update(approved: true)

  end

  def denyUserRequest
    user = User.find(params[:user])
    user.destroy
  end

  def admin

  end
end
