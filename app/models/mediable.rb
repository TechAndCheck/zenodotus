module Mediable
  extend ActiveSupport::Concern

  included do
    has_one :media_item, as: :mediable, touch: true, dependent: :destroy
  end
end
