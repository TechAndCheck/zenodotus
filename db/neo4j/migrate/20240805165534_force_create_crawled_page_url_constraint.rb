class ForceCreateCrawledPageUrlConstraint < ActiveGraph::Migrations::Base
  def up
    add_constraint :CrawledPage, :url, force: true
  end

  def down
    drop_constraint :CrawledPage, :url
  end
end
