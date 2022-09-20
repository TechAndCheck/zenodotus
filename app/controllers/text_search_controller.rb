# typed: strict

class TextSearchController < ApplicationController
  before_action :authenticate_user!

  sig { void }
  def index
    @search = TextSearch.new
    @results = nil
  end

  # A class representing the allowed params into the `search` endpoint
  class SubmitUrlParams < T::Struct
    const :query, String
  end

  # Searches for posts and authors matching a search term
  #
  # @param {search_term} a user-submitted search term
  sig { void }
  def search
    typed_params = TypedParams[SubmitUrlParams].new.extract!(params)

    # Create a search object
    search = TextSearch.create(query: typed_params.query, user: current_user)
    results = search.run

    @post_search_hits = []
    @user_search_hits = []

    post_models = [Sources::Tweet, Sources::InstagramPost, Sources::FacebookPost, Sources::YoutubePost]

    # Split up search results by type
    results.each do |record|
      if post_models.include? record.class
        @post_search_hits.append(record)
      else
        @user_search_hits.append(record)
      end
    end

    respond_to do | format |
      format.html { render "search" }
    end
  end
end
