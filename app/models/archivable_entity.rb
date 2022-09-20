# typed: true

module ArchivableEntity
  extend ActiveSupport::Concern

  included do
    has_one :archive_entity, as: :archivable_entity, touch: true, dependent: :destroy
  end
end
