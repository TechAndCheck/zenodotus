# typed: strict
require "zelkova"

Rails.configuration.after_initialize do
  # Build up the graph
  graph = Zelkova.graph
  graph.radius = 6

  ImageHash.all.each do |image_hash|
    graph.add_node(image_hash.dhash, { id: image_hash.id })
  end
rescue ActiveRecord::NoDatabaseError, ActiveRecord::StatementInvalid
  # Do nothing, this means the database isn't created yet
end
