# typed: true

class ImageHash < ApplicationRecord
  belongs_to :archive_item

  after_create do
    Zelkova.graph.add_node(self.dhash, { id: self.id })
  end
end
