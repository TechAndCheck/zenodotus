class MediaModels::Tweet
  include ActiveGraph::Node
  include ActiveGraph::Timestamps

  property :text
  property :id, type: Integer
  property :language

  validates :text, presence: true
  validates :language, presence: true
  validates :id, presence: true
  validates :id, numericality: { only_integer: true }
end
