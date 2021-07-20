# typed: ignore

class IngestController < ApplicationController
  # Submit MediaReview data, which the URL will be scraped from
  sig { void }
  def submit_mediareview
    # Spin off an active job to handle this
  end
end
