class ForceCreateCrawledPageUuidConstraint < ActiveGraph::Migrations::Base
  def up
    add_constraint :CrawledPage, :uuid, force: true
  end

  def down
    drop_constraint :CrawledPage, :uuid
  end
end
