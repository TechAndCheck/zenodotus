# typed: strict

class AdminController < ApplicationController
  before_action :authenticate_super_user!

  sig { void }
  def dashboard; end
end
