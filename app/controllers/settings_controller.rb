# frozen_string_literal: true

class SettingsController < ApplicationController
  require 'sidekiq/api'


  def approveUserRequest
    user = User.find(params[:user])
    user.update(approved: true)
  end

  def denyUserRequest
    user = User.find(params[:user])
    user.destroy
  end

  def admin; end
end
