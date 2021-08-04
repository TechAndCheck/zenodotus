# typed: strict
class ApplicationController < ActionController::Base
  extend T::Sig
  extend T::Helpers

  acts_as_token_authentication_handler_for User

end
