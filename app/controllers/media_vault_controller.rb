# typed: strict

class MediaVaultController < ApplicationController
  before_action :authenticate_user!
end
