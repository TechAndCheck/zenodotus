require "active_graph"

class Page
  include ActiveGraph::Node

  property :url, type: String
  property :host_name, type: String
  property :has_claim_review?, type: Boolean
  property :number_of_claims_linked, type: Integer, default: 0

  validates :number_of_claims_linked, numericality: { only_integer: true }

  has_many :out, :pages, type: :page, model_class: :Page, unique: true, dependent: :delete
end
