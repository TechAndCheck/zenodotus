# typed: false

class ArchiveEntity < ApplicationRecord
  delegated_type :archivable_entity, types: %w[ Sources::TwitterUser Sources::InstagramUser]
  delegate :service_id, to: :archivable_entity

  # Note: You may want to use `alias` or `alias_method` here instead of the following functions
  # it *does not* work. Probably because of the `delegated_type` metaprogramming, but hacking that
  # is a bad idea.

  # A helper function to make it easier to access the user, instead of `.sources_twitter_user`
  # this allows just the use of `.twitter_user`
  #
  # @returns +Sources::TwitterUser+
  sig { returns(T.nilable(Sources::TwitterUser)) }
  def twitter_user
    self.sources_twitter_user
  end

  # A helper function to make it easier to access the user, instead of `.sources_instagram_user`
  # this allows just the use of `.instagram_user`
  #
  # @returns +Sources::InstagramUser+
  sig { returns(T.nilable(Sources::InstagramUser)) }
  def instagram_user
    self.sources_instagram_user
  end
end
