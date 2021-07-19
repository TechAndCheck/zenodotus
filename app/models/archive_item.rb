# typed:false

class ArchiveItem < ApplicationRecord
  delegated_type :archivable_item, types: %w[ Sources::Tweet Sources::InstagramPost ]
  delegate :service_id, to: :archivable_item
  delegate :images, to: :archivable_item
  delegate :videos, to: :archivable_item

  # Note: You may want to use `alias` or `alias_method` here instead of the following functions
  # it *does not* work. Probably because of the `delegated_type` metaprogramming, but hacking that
  # is a bad idea.

  # A helper function to make it easier to access the itme, instead of `.sources_tweet`
  # this allows just the use of `.tweet`
  #
  # @returns +Sources::Tweet+
  sig { returns(T.nilable(Sources::Tweet)) }
  def tweet
    self.sources_tweet
  end

  # A helper function to make it easier to access the user, instead of `.sources_instagram_post`
  # this allows just the use of `.instagram_post`
  #
  # @returns +Sources::InstagramPost+
  sig { returns(T.nilable(Sources::InstagramPost)) }
  def instagram_post
    self.sources_instagram_post
  end
end
