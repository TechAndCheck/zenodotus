# typed: strict
class ApplicationController < ActionController::Base
  extend T::Sig
  extend T::Helpers

  # Return a class that can handle a given +url+
  sig { params(url: String).returns(T.nilable(Class)) }
  def model_for_url(url)
    # Load all models so we can inspect them
    Zeitwerk::Loader.eager_load_all

    # Get all models conforming to ApplicationRecord, and then check if they implement the magic
    # function.
    models = ApplicationRecord.descendants.select do |model|
      if model.respond_to? :can_handle_url?
        model.can_handle_url?(url)
      end
    end

    # We'll always choose the first one
    models.first
  end
end
