# typed: false
module ArchivableItem
  extend ActiveSupport::Concern

  included do
    has_one :archive_item, as: :archivable_item, touch: true, dependent: :destroy
  end
end
